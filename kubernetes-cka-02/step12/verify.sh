#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {


  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "12:KO >> /opt/.logs/status.log"
    return 0
  fi
  
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
    echo "12:OK" >> "/opt/.logs/status.log"
    return 0
  fi
  
}

verify_step

exit $?
