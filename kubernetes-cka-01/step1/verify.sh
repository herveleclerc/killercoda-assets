#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {
  content=$(${kctl} get pods --no-headers --selector run=nginx-pod  | grep nginx-pod | awk '{print $3;}')

  if [[ "$content" == "Running" ]]
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
