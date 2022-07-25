#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "6:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  create=$(${kctl} auth can-i create pods --as=alterway --namespace=development)
  watch=$(${kctl} auth can-i watch pods --as=alterway --namespace=development)
  

  if [[ "$create" == "yes" ]]
  then
      if [[ "$watch" == "no" ]]
      then
        echo "Verification passed"
        echo "6:OK" >> "/opt/.logs/status.log"
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
