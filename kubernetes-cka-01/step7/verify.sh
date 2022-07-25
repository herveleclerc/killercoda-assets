#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "7:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  hostname=$(hostname)

  content=$(${kctl} get pod --no-headers --selector run=static-pod  | grep static-pod-${hostname} | awk '{print $3;}')
  

  if [[ "$content" == "Running" ]]
  then
    echo "Verification passed"
    echo "7:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
