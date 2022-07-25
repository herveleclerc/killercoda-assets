#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {

  content=$(${kctl} get ns --no-headers | grep cka-001 | awk '{print $2;}')
  
  if [[ "$content" == "Active" ]]
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
