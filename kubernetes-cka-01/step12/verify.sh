#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "12:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  content=$(${kctl} get pv --no-headers | grep pv-analytics | awk '{print $1" "$2" "$3" "$5;}')
  path=$(${kctl} get -o jsonpath='{.spec.hostPath.path}' pv pv-analytics)

  if [[ "$content" == "pv-analytics 100Mi RWX Available" ]]
  then
    if [[ "$path" == "/pv/data-analytics" ]]
    then
      echo "Verification passed"
      echo "1:OK" >> "/opt/.logs/status.log"
      return 0
    else
      echo "Verification failed"
      return 1
    fi
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
