#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  create=$(${kctl} auth can-i create pods --as=alterway --namespace=development)
  watch=$(${kctl} auth can-i watch pods --as=alterway --namespace=development)
  

  if [[ "$create" == "yes" ]]
  then
      if [[ "$watch" == "no" ]]
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
