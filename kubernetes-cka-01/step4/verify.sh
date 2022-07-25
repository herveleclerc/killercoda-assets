#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  content=$(${kctl} get nodes -o json | jq -r '.items[0].metadata.name')

  if [ -f "/tmp/nodes.json" ]; then
    controplane=$(cat < "/tmp/nodes.json" | jq -r '.items[0].metadata.name')
  else 
    return 2
  fi
  
  if [[ "$content" == "$controplane" ]]
  then
    echo "Verification passed"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
