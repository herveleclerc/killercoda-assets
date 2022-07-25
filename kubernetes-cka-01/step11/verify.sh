#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "11:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  content=$(${kctl} get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}')

  if [ -f "/tmp/osImage.txt" ]; then
    osImage=$(cat < "/tmp/osImage.txt")
  else 
    return 2
  fi
  
  if [[ "$content" == "$osImage" ]]
  then
    echo "Verification passed"
    echo "11:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
