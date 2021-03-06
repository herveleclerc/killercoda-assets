#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "1:KO >> /opt/.logs/status.log"
    return 0
  fi

  content=$(${kctl} get pods --no-headers --selector run=nginx-pod  | grep nginx-pod | awk '{print $3;}')

  if [[ "$content" == "Running" ]]
  then
    echo "Verification passed"
    echo "1:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
}

verify_step

exit $?
