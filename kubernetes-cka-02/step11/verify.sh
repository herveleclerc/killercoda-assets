#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "11:KO >> /opt/.logs/status.log"
    return 0
  fi
  
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
    echo "11:OK" >> "/opt/.logs/status.log"
    return 0
  fi
  
}

verify_step

exit $?
