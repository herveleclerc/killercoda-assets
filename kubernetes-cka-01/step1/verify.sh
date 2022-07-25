#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

content=$(${kctl} get pods --no-headers --selector run=nginx-pod  | grep nginx-pod | awk '{print $3;}')
  
function verify_step_1() {
  if [[ "$content" == "Running" ]]
  then
    echo "Verification passed"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
}

verify_step_1

exit $?
