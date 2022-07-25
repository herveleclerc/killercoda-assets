#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  if [[ ! -f "/tmp/mystery.txt" ]]
  then
    echo "Verification failed"
    return 2
  fi

  c=$(grep -c BONJOURBONJOUR '/tmp/mystery.txt')
  if [[ $c -ne 1 ]]
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
