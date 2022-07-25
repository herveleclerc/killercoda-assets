#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "1:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  if [[ ! -f "/tmp/healthchecking.txt" ]]
  then
    echo "Verification failed"
    return 2
  fi
 
  c=$(grep -c "Liveness.*probe.*failed:.*HTTP.*probe.*failed.*with.*statuscode:.*403" /tmp/healthchecking.txt)
  
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
