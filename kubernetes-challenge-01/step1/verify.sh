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
          app: frontend
    ports:
    - protocol: TCP
      port: 80
EOF
      echo "Verification failed"
      return 1
    else
        echo "NetworkPolicy backend-allow-frontend already exists."
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
ensure_network_policy

# Exécuter la vérification
verify_step

exit $?
