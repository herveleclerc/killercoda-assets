#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  if [[ ! -f "/tmp/pod-over-request.txt" ]]
  then
    echo "Verification failed"
    return 2
  fi
 
  c=$(grep -c "requested:.*requests.memory=1500M,.*used:.*requests.memory=0,.*limited:.*requests.memory=1Gi" /tmp/pod-over-request.txt)
  
  if [[ "$c" == "1" ]]
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
