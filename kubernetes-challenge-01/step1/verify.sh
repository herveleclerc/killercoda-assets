#!/bin/bash

export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

function ensure_network_policy() {
    if ! $kctl get networkpolicy backend-allow-frontend &>/dev/null; then
        echo "NetworkPolicy backend-allow-frontend not found. Creating it."
        cat <<EOF | $kctl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow-frontend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend-app
    ports:
    - protocol: TCP
      port: 80
EOF
      echo "Verification failed"
      return 1
    else
        echo "NetworkPolicy backend-allow-frontend already exists."
        return 0
    fi
}

ensure_label(){
  # Vérifier si la NetworkPolicy existe
if ! kubectl get networkpolicy "$NETWORK_POLICY_NAME" &>/dev/null; then
    echo "NetworkPolicy $NETWORK_POLICY_NAME does not exist."
   return 1
fi

# Extraire le champ matchLabels.app des règles from[].podSelector
APP_LABEL=$(kubectl get networkpolicy "$NETWORK_POLICY_NAME" -o jsonpath='{.spec.ingress[*].from[*].podSelector.matchLabels.app}')

# Vérifier si frontend est bien présent
if [[ "$APP_LABEL" == "frontend" ]]; then
    echo "✅ La NetworkPolicy contient bien 'frontend' dans les règles Ingress."
    return 0
else
    echo "❌ ERREUR : La NetworkPolicy ne contient PAS 'frontend'."
    return 1
fi
}


function verify_step() {
    if [ -f "/opt/.logs/give_up" ]; then
        echo "give_up file found, exiting"
        rm -f "/opt/.logs/give_up"
        echo "1:KO >> /opt/.logs/status.log"
        return 0
    fi

    content=$(cat /tmp/backend-message.txt 2>/dev/null | grep "AlterWay2025-AWCC")
  
    if [[ "$content" == "AlterWay2025-AWCC" ]]
    then
        echo "Verification passed"
        echo "1:OK" >> "/opt/.logs/status.log"
        return 0
    else
        echo "Verification failed"
        return 1
    fi
}

# Vérifier et créer la NetworkPolicy si nécessaire
ensure_network_policy || exit $?

# Vérifier si le label est correct
ensure_label || exit $?

# Exécuter la vérification
verify_step

exit $?
