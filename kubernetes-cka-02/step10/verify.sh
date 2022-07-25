#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  c=$(${kctl} get po -n constraints -o wide | grep app001 | grep -c node01)
 
  
  if [ $c -ne 2 ]
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
