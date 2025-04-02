#!/bin/bash

# set -x # to test stderr output in /var/log/killercoda

echo starting... # to test stdout output in /var/log/killercoda


helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace --wait --timeout 300s


DEPLOYMENT_NAME="backend-deployment"
NAMESPACE="default"
TIMEOUT=60  # Temps max d'attente en secondes
INTERVAL=5  # Intervalle entre chaque vérification


kubectl apply -f /root/backend-deployment.yaml
kubectl apply -f /root/backend-service.yaml
kubectl apply -f /root/backend-netpol-broken.yaml
kubectl apply -f /root/frontend-deployment.yaml

kubectl apply -f /root/kyverno-policy.yaml

echo "🔍 Attente du Pod du déploiement '$DEPLOYMENT_NAME' dans le namespace '$NAMESPACE'..."

end=$((SECONDS + TIMEOUT))

while [ $SECONDS -lt $end ]; do
    POD_STATUS=$(kubectl get pods -n $NAMESPACE -l app=backend --field-selector=status.phase=Running --no-headers | wc -l)

    if [ "$POD_STATUS" -gt 0 ]; then
        echo "✅ Pod en état Running !"
        break  # Continue sans quitter le script
    fi

    echo "⏳ En attente du Pod..."
    sleep $INTERVAL
done

if [ "$POD_STATUS" -eq 0 ]; then
    echo "❌ Timeout ! Le Pod n'est pas passé en état Running dans le délai imparti."
fi

echo "🚀 Continuation des étapes suivantes..."

kubectl exec -it $(kubectl get pods -n $NAMESPACE -l app=backend --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c 'echo "AlterWay2025-AWCC" > /usr/share/nginx/html/index.html'


rm -f /root/backend-deployment.yaml
rm -f /root/backend-service.yaml
rm -f /root/backend-netpol-broken.yaml
rm -f /root/frontend-deployment.yaml
rm -f /root/kyverno-policy.yaml


echo "done" > /tmp/background0