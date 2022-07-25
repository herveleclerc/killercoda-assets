#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "3:KO >> /opt/.logs/status.log"
    return 0
  fi

  content=$(${kctl} get ns --no-headers | grep cka-001 | awk '{print $2;}')
  
  if [[ "$content" == "Active" ]]
  then
    echo "Verification passed"
    echo "3:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
