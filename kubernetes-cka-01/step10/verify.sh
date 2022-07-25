#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "10:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  curl -s -o /dev/null localhost:30082

  retVal=$?

  if [ $retVal -ne 0 ]
  then
    echo "Verification failed"
    return 1
  else
    echo "Verification passed"
    echo "10:OK" >> "/opt/.logs/status.log"
    return 0
  fi
  
}

verify_step

exit $?
