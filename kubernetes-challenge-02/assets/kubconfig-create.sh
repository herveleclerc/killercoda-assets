#!/bin/bash

# ---- Configuration ----
# Nom d'utilisateur K8s (sera utilisé comme Common Name (CN) dans le certificat)
USERNAME="${1}"
# Groupe K8s (optionnel, utilisé comme Organization (O) dans le certificat, utile pour RBAC)
# Si vous ne voulez pas de groupe, laissez vide : GROUP=""
GROUP="developers" # Exemple: mettez vos groupes ici ou laissez vide

# Namespace et Rôle pour le RoleBinding (Optionnel - Décommentez et configurez pour créer RBAC)
CREATE_RBAC="true"
TARGET_NAMESPACE="awcc" # Namespace où l'utilisateur aura des droits
K8S_ROLE="awcc" # Rôle à assigner (ex: view, edit, admin, ou un rôle custom)


# ---- Validation ----
if [[ -z "$USERNAME" ]]; then
  echo "Erreur : Nom d'utilisateur manquant."
  echo "Usage: $0 <username>"
  exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "Erreur : kubectl n'est pas installé ou non trouvé dans le PATH."
    exit 1
fi

if ! command -v openssl &> /dev/null; then
    echo "Erreur : openssl n'est pas installé ou non trouvé dans le PATH."
    exit 1
fi

# Vérifier la connexion au cluster
echo "Vérification de la connexion au cluster Kubernetes..."
if ! kubectl cluster-info &> /dev/null; then
    echo "Erreur : Impossible de se connecter au cluster Kubernetes. Vérifiez votre configuration kubectl."
    exit 1
fi
echo "Connecté au cluster."


# ---- Variables ----
KEY_FILE="${USERNAME}.key"
CSR_FILE="${USERNAME}.csr"
CERT_FILE="${USERNAME}.crt"
KUBECONFIG_FILE="${USERNAME}.kubeconfig"
CSR_NAME="${USERNAME}-csr"
TMP_CA_FILE="" # Variable pour le fichier CA temporaire si besoin

# Fonction de nettoyage pour le fichier CA temporaire
cleanup() {
  if [[ -n "$TMP_CA_FILE" && -f "$TMP_CA_FILE" ]]; then
    echo "Nettoyage du fichier CA temporaire..."
    rm -f "${TMP_CA_FILE}"
  fi
  # Nettoyage du CSR k8s en cas d'erreur prématurée
  # kubectl get csr "${CSR_NAME}" &>/dev/null && kubectl delete csr "${CSR_NAME}"
}
trap cleanup EXIT # Assure le nettoyage même en cas d'erreur

# Définir le sujet du certificat
CERT_SUBJECT="/CN=${USERNAME}"
if [[ -n "$GROUP" ]]; then
  CERT_SUBJECT="${CERT_SUBJECT}/O=${GROUP}"
fi
echo "Sujet du certificat : ${CERT_SUBJECT}"

# ---- Génération Clé et CSR ----
echo "Génération de la clé privée (${KEY_FILE})..."
openssl genrsa -out "${KEY_FILE}" 2048
if [[ $? -ne 0 ]]; then echo "Erreur lors de la génération de la clé privée."; exit 1; fi

echo "Génération de la demande de signature de certificat (CSR) (${CSR_FILE})..."
openssl req -new -key "${KEY_FILE}" -out "${CSR_FILE}" -subj "${CERT_SUBJECT}"
if [[ $? -ne 0 ]]; then echo "Erreur lors de la génération du CSR."; exit 1; fi

# ---- Création et Approbation du CSR K8s ----
echo "Encodage du CSR en Base64..."
CSR_B64=$(cat "${CSR_FILE}" | base64 | tr -d '\n')
if [[ -z "$CSR_B64" ]]; then echo "Erreur lors de l'encodage du CSR."; exit 1; fi

echo "Création de l'objet CertificateSigningRequest Kubernetes (${CSR_NAME})..."
# Supprimer un ancien CSR du même nom s'il existe et n'est pas approuvé/délivré
kubectl delete csr "${CSR_NAME}" --ignore-not-found=true
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${CSR_NAME}
spec:
  request: ${CSR_B64}
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400 # Optionnel : durée de validité du certificat (ici 1 jour)
  usages:
  - client auth
EOF
if [[ $? -ne 0 ]]; then echo "Erreur lors de la création du CSR Kubernetes."; exit 1; fi

echo "Approbation du CSR (${CSR_NAME})... (Nécessite les droits admin)"
kubectl certificate approve "${CSR_NAME}"
if [[ $? -ne 0 ]]; then echo "Erreur lors de l'approbation du CSR."; exit 1; fi

# ---- Récupération du Certificat Signé ----
echo "Attente de la délivrance du certificat..."
CERT_B64=""
retries=10
delay=3
while [[ -z "$CERT_B64" && $retries -gt 0 ]]; do
  CERT_B64=$(kubectl get csr "${CSR_NAME}" -o jsonpath='{.status.certificate}')
  if [[ -z "$CERT_B64" ]]; then
    echo "Certificat pas encore prêt, nouvelle tentative dans ${delay}s... (${retries} restantes)"
    sleep ${delay}
    retries=$((retries - 1))
  fi
done

if [[ -z "$CERT_B64" ]]; then
  echo "Erreur : Timeout lors de la récupération du certificat signé pour ${CSR_NAME}."
  echo "Vérifiez manuellement avec: kubectl get csr ${CSR_NAME}"
  exit 1
fi

echo "Certificat récupéré. Décodage et sauvegarde dans (${CERT_FILE})..."
echo "${CERT_B64}" | base64 --decode > "${CERT_FILE}"
if [[ $? -ne 0 ]]; then echo "Erreur lors du décodage ou de la sauvegarde du certificat."; exit 1; fi

# ---- Récupération Infos Cluster ----
echo "Récupération des informations du cluster depuis le contexte kubectl actuel..."
CURRENT_CONTEXT=$(kubectl config current-context)
CLUSTER_NAME=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"${CURRENT_CONTEXT}\")].context.cluster}")
SERVER_URL=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"${CLUSTER_NAME}\")].cluster.server}")

# Essayer de récupérer CA data OU CA file path
CA_DATA=$(kubectl config view --raw -o jsonpath="{.clusters[?(@.name==\"${CLUSTER_NAME}\")].cluster.certificate-authority-data}")
CA_FILE_PATH=$(kubectl config view --raw -o jsonpath="{.clusters[?(@.name==\"${CLUSTER_NAME}\")].cluster.certificate-authority}")

CA_ARG=""
if [[ -n "$CA_DATA" ]]; then
    # Si CA data existe, on doit l'écrire dans un fichier temporaire
    # car set-cluster --certificate-authority attend un chemin de fichier.
    TMP_CA_FILE=$(mktemp /tmp/kubeconfig-ca-XXXXXX.crt)
    echo "Utilisation de certificate-authority-data (via fichier temporaire: ${TMP_CA_FILE})"
    echo "${CA_DATA}" | base64 --decode > "${TMP_CA_FILE}"
    if [[ $? -ne 0 ]]; then echo "Erreur lors de l'écriture du fichier CA temporaire."; exit 1; fi
    CA_ARG="--certificate-authority=${TMP_CA_FILE}"
elif [[ -n "$CA_FILE_PATH" && -f "$CA_FILE_PATH" ]]; then
    # Si un chemin de fichier CA existe et est valide, on l'utilise directement.
    echo "Utilisation de certificate-authority depuis : ${CA_FILE_PATH}"
    CA_ARG="--certificate-authority=${CA_FILE_PATH}"
else
    echo "Erreur critique : Impossible de trouver 'certificate-authority-data' OU un fichier 'certificate-authority' valide"
    echo "dans la configuration du cluster '${CLUSTER_NAME}' du kubeconfig source (${HOME}/.kube/config ou KUBECONFIG env var)."
    echo "Impossible de configurer le cluster pour le nouveau kubeconfig."
    exit 1
fi

if [[ -z "$CLUSTER_NAME" || -z "$SERVER_URL" ]]; then
    echo "Erreur : Impossible de récupérer le nom du cluster ou l'URL du serveur depuis le contexte '${CURRENT_CONTEXT}'."
    exit 1
fi


# ---- Création du Kubeconfig ----
echo "Création du fichier Kubeconfig (${KUBECONFIG_FILE})..."

# Configurer le cluster en fournissant le CA immédiatement
kubectl config set-cluster "${CLUSTER_NAME}" \
  --server="${SERVER_URL}" \
  --kubeconfig="${KUBECONFIG_FILE}" \
  ${CA_ARG} \
  --embed-certs=true # Ceci fonctionne maintenant car ${CA_ARG} fournit le cert CA
if [[ $? -ne 0 ]]; then echo "Erreur lors de la configuration du cluster dans ${KUBECONFIG_FILE}."; exit 1; fi

# Le fichier CA temporaire n'est plus nécessaire après set-cluster si --embed-certs=true a réussi
# Le nettoyage se fera via le trap EXIT

# Configurer les identifiants utilisateur
kubectl config set-credentials "${USERNAME}" \
  --client-key="${KEY_FILE}" \
  --client-certificate="${CERT_FILE}" \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG_FILE}"
if [[ $? -ne 0 ]]; then echo "Erreur lors de la configuration des identifiants utilisateur dans ${KUBECONFIG_FILE}."; exit 1; fi

# Configurer le contexte
kubectl config set-context "${USERNAME}-context" \
  --cluster="${CLUSTER_NAME}" \
  --user="${USERNAME}" \
  --kubeconfig="${KUBECONFIG_FILE}"
  # Optionnel: Définir le namespace par défaut pour ce contexte
  # --namespace="${TARGET_NAMESPACE:-default}" \
if [[ $? -ne 0 ]]; then echo "Erreur lors de la configuration du contexte dans ${KUBECONFIG_FILE}."; exit 1; fi


# Définir le contexte actuel dans le nouveau fichier kubeconfig
kubectl config use-context "${USERNAME}-context" --kubeconfig="${KUBECONFIG_FILE}"
if [[ $? -ne 0 ]]; then echo "Erreur lors de la définition du contexte actuel dans ${KUBECONFIG_FILE}."; exit 1; fi

echo "Fichier Kubeconfig créé : ${KUBECONFIG_FILE}"

# ---- Création RBAC (Optionnel) ----
if [[ "$CREATE_RBAC" == "true" ]]; then
  if [[ -z "$TARGET_NAMESPACE" || -z "$K8S_ROLE" ]]; then
    echo "Avertissement : CREATE_RBAC est activé mais TARGET_NAMESPACE ou K8S_ROLE ne sont pas définis. Le RBAC ne sera pas créé."
  else
    echo "Création du RoleBinding pour l'utilisateur '${USERNAME}' dans le namespace '${TARGET_NAMESPACE}' avec le rôle '${K8S_ROLE}'..."
    # Vérifier si le rôle est ClusterRole ou Role (simple heuristique)
    ROLE_KIND="Role"
    if kubectl get clusterrole "$K8S_ROLE" &> /dev/null; then
        ROLE_KIND="ClusterRole"
        echo "Utilisation du ClusterRole: $K8S_ROLE"
    elif kubectl get role "$K8S_ROLE" -n "$TARGET_NAMESPACE" &> /dev/null; then
        echo "Utilisation du Role: $K8S_ROLE dans le namespace $TARGET_NAMESPACE"
    else
        echo "Avertissement: Le rôle '$K8S_ROLE' n'a été trouvé ni comme ClusterRole ni comme Role dans le namespace '$TARGET_NAMESPACE'. Le RoleBinding pourrait échouer ou ne pas fonctionner."
        # On tente quand même avec Role par défaut, l'admin devra peut-être créer le rôle d'abord.
    fi

    cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${USERNAME}-binding-${K8S_ROLE} # Nom plus spécifique
  namespace: ${TARGET_NAMESPACE}
subjects:
- kind: User
  name: ${USERNAME} # Doit correspondre au CN du certificat
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ${ROLE_KIND} # Role ou ClusterRole
  name: ${K8S_ROLE} # Nom du rôle (ex: view, edit, ou un rôle custom)
  apiGroup: rbac.authorization.k8s.io
EOF
    if [[ $? -ne 0 ]]; then
        echo "Erreur lors de la création du RoleBinding."
        echo "Vérifiez que le namespace '${TARGET_NAMESPACE}' et le rôle '${K8S_ROLE}' existent et que vous avez les permissions nécessaires."
    else
        echo "RoleBinding créé avec succès."
    fi
  fi
fi


# ---- Nettoyage (Optionnel) ----
# echo "Nettoyage des fichiers intermédiaires (.csr)..."
# rm -f "${CSR_FILE}"
# echo "Conservez précieusement ${KEY_FILE}, ${CERT_FILE} et ${KUBECONFIG_FILE}"
# echo "Vous pouvez supprimer le CSR de Kubernetes si vous le souhaitez (peut être utile pour le suivi):"
# echo "kubectl delete csr ${CSR_NAME}"


# ---- Instructions Finales ----
echo ""
echo "------------------------------------------------------------------"
echo " Terminé !"
echo " Fichier Kubeconfig généré : ${PWD}/${KUBECONFIG_FILE}"
echo " Clé privée de l'utilisateur : ${PWD}/${KEY_FILE}"
echo " Certificat de l'utilisateur : ${PWD}/${CERT_FILE}"
echo "------------------------------------------------------------------"
echo ""
echo "Pour utiliser ce Kubeconfig :"
echo "1. Transmettez le fichier '${KUBECONFIG_FILE}' de manière sécurisée à l'utilisateur '${USERNAME}'."
echo "2. L'utilisateur peut l'utiliser avec kubectl :"
echo "   export KUBECONFIG=${PWD}/${KUBECONFIG_FILE}"
echo "   kubectl get pods"
echo "   (Ou copier/fusionner ce fichier dans son ~/.kube/config)"
echo ""
if [[ "$CREATE_RBAC" != "true" ]]; then
  echo "IMPORTANT : N'oubliez pas de créer les autorisations RBAC nécessaires"
  echo "(Role, ClusterRole, RoleBinding, ClusterRoleBinding) pour que l'utilisateur"
  echo "'${USERNAME}' puisse effectuer des actions dans le cluster."
  echo "Exemple pour donner le rôle 'view' dans le namespace 'default' :"
  echo "kubectl create rolebinding ${USERNAME}-view-binding --clusterrole=view --user=${USERNAME} --namespace=default"
fi
echo ""

# Le trap EXIT s'occupera du nettoyage final du fichier CA temporaire si besoin.
exit 0