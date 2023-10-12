#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "2:KO >> /opt/.logs/status.log"
    return 0
  fi


  content=$(${kctl} get pods -n default --no-headers --selector run=elliphant | grep elliphant | awk '{print $3;}')
  request_cpu=$(${kctl} get -n default -o jsonpath='{.spec.containers[0].resources.requests.cpu}' po elliphant)
  request_memory=$(${kctl} get -n default -o jsonpath='{.spec.containers[0].resources.requests.memory}' po elliphant)

  if [[ "$content" == "Running" ]]
  then
    if [[ "$request_cpu" == "250m" ]]
    then
      if [[ "$request_memory" == "200Mi" ]]
      then
        echo "Verification passed"
        echo "2:OK" >> "/opt/.logs/status.log"
        return 0
      else
        echo "Verification failed"
        return 1
      fi
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
