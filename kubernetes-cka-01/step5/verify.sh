#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {
  
  content=$(${kctl} get services -l tier=msg --no-headers | grep messaging-service | awk '{print $1" "$2;}')
  
  if [[ "$content" == "messaging-service ClusterIP" ]]
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
