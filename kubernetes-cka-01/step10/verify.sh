#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  curl -s -o /dev/null localhost:30082

  retVal=$?

  if [ $retVal -ne 0 ]
  then
    echo "Verification failed"
    return 1
  else
    echo "Verification passed"
    return 0
  fi
  
}

verify_step

exit $?
