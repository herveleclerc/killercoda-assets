#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "5:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  content=$(${kctl} get services -l tier=msg --no-headers | grep messaging-service | awk '{print $1" "$2;}')
  
  if [[ "$content" == "messaging-service ClusterIP" ]]
  then
    echo "Verification passed"
    echo "5:OK" >> "/opt/.logs/status.log"
    return 0
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
