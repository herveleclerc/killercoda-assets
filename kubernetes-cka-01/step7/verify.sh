#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  hostname=$(hostname)

  content=$(${kctl} get pod --no-headers --selector run=static-pod  | grep static-pod-${hostname} | awk '{print $3;}')
  

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
