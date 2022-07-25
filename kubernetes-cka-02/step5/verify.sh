#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {
  
  content=$(${kctl} get pods -n default --no-headers --selector app=nginx-deploy | grep nginx-deploy | awk '{print $3;}')
  
  annotation=$(${kctl} get -n default -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io\/revision}' deploy nginx-deploy)
  

  if [[ "$content" == "Running" ]]
  then
      if [[ "$annotation" == "2" ]]
      then
        echo "Verification passed"
        return 0
      else
        echo "Verification failed"
        return 1
      fi
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
