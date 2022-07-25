#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  if [[ ! -f "/tmp/supersecret.txt" ]]
  then
    echo "Verification failed"
    return 2
  fi


  diff '/opt/.logs/supersecret.txt' '/tmp/supersecret.txt'
  if [[ $? -ne 0 ]]
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
