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

kubectl create namespace awcc 
kubectl apply -f /tmp/awcc-role.yaml -n awcc

kubectl apply -f /tmp/compromised-pod-deployment.yaml -n awcc
kubectl apply-f /tmp/secret-holder-pod.yaml -n awcc
kubectl apply -f /tmp/rbac-misconfiguration.yaml -n awcc

bash /usr/local/bin/kubconfig-create.sh awcc

mkdir -p /opt/.logs
mv ~/.kube/config /opt/.logs/config
mv awcc.kubeconfig ~/.kube/config
rm awcc*

echo "#####################################################"
echo "## Environnement Kubernetes prêt pour le challenge ! ##"
echo "#####################################################"
echo ""
echo "Suivez les instructions dans l'onglet de gauche pour commencer."

exit 0