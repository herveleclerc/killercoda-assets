#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  content=$(${kctl} get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}')

  if [ -f "/tmp/osImage.txt" ]; then
    osImage=$(cat < "/tmp/osImage.txt")
  else 
    return 2
  fi
  
  if [[ "$content" == "$osImage" ]]
  then
    echo "Verification passed"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
