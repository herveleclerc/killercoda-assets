#!/bin/bash

echo "############################################"
echo "## Préparation de l'environnement K8s... ##"
echo "############################################"

# Attendre que le control-plane et le worker soient prêts
echo "--> Attente de la disponibilité des nœuds K8s..."
kubectl wait --for=condition=Ready node --all --timeout=300s
echo "--> Nœuds prêts !"

# Créer les fichiers YAML nécessaires
echo "--> Création des fichiers de configuration Kubernetes..."

# 1. Deployment du Pod compromis (point d'entrée)
cat << EOF > compromised-pod-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      # Utilise le SA par défaut, qui sera lié au rôle ci-dessous
      automountServiceAccountToken: true
      containers:
      - name: frontend-container
        # Image avec curl
        image: alpine:latest 
        command: ["sleep", "3600"]
EOF

# 2. Pod contenant le secret (la cible)
cat << EOF > secret-holder-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: legacy-internal-db
  labels:
    app: database
    tier: internal
  annotations:
    description: "Pod critique - Ne pas toucher - Contient des données sensibles"
spec:
  containers:
  - name: db-container
    image: busybox
    # Le flag est écrit dans ce fichier au démarrage du pod
    command: ["sh", "-c", "echo 'KUBE{3sc4p3d_Th3_S4ndb0x_Successfully}' > /data/secret_flag.txt && sleep 3600"]
    # Faille de sécurité : Pod privilégié !
    securityContext:
      privileged: true
    volumeMounts:
    - name: data-storage
      mountPath: /data
  volumes:
  - name: data-storage
    emptyDir: {}
  # Assigner au worker node pour garantir sa localisation
  nodeSelector:
    kubernetes.io/hostname: node01
EOF

# 3. Configuration RBAC délibérément faible
cat << EOF > rbac-misconfiguration.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: default-pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "secrets"] # Autorise lecture pods/secrets
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/exec"] # Faille : Autorise l'exec dans les pods !
  verbs: ["create", "get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: bind-default-sa-to-reader
  namespace: default
subjects:
- kind: ServiceAccount
  name: default # Lie le rôle au ServiceAccount PAR DÉFAUT
  namespace: default
roleRef:
  kind: Role
  name: default-pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF

# Appliquer les configurations
echo "--> Application des configurations RBAC..."
kubectl apply -f rbac-misconfiguration.yaml

echo "--> Déploiement du pod 'frontend-app'..."
kubectl apply -f compromised-pod-deployment.yaml

echo "--> Déploiement du pod 'legacy-internal-db'..."
kubectl apply -f secret-holder-pod.yaml

# Attendre que les pods soient prêts
echo "--> Attente du démarrage des pods..."
kubectl wait --for=condition=available deployment/frontend-app --timeout=180s -n default
kubectl wait --for=condition=ready pod/legacy-internal-db --timeout=180s -n default

echo "#####################################################"
echo "## Environnement Kubernetes prêt pour le challenge ! ##"
echo "#####################################################"
echo ""
echo "Suivez les instructions dans l'onglet de gauche pour commencer."

exit 0