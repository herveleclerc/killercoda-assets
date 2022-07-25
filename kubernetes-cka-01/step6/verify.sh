#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  content=$(${kctl} get deploy --no-headers --selector app=hr-web-app  | grep hr-web-app | awk '{print $2;}')
  

  if [[ "$content" == "2/2" ]]
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
