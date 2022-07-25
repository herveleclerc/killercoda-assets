#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {

  content=$(${kctl} get pods -n default --no-headers --selector run=super-user-pod | grep super-user-pod | awk '{print $3;}')
  capabilities=$(${kctl} get -n default -o jsonpath='{.spec.containers[0].securityContext.capabilities.add[0]}' po super-user-pod)
  

  if [[ "$content" == "Running" ]]
  then
      if [[ "$capabilities" == "SYS_TIME" ]]
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
