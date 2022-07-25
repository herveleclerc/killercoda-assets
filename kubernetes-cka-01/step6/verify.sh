#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "6:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  content=$(${kctl} get deploy --no-headers --selector app=hr-web-app  | grep hr-web-app | awk '{print $2;}')
  

  if [[ "$content" == "2/2" ]]
  then
    echo "Verification passed"
    echo "6:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
