#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {


  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "1:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  content=$(${kctl} get pods -n default --no-headers --selector run=use-pv | grep use-pv | awk '{print $3;}')

  nv=$(${kctl} get -n default po use-pv -o json | jq '.spec.containers[0].volumeMounts | length')


  if [[ "$content" == "Running" ]]
  then      
     for (( i=0; i<$nv; i++ ))
     do
      mountpath=$(${kctl} get -n default -o jsonpath="{.spec.containers[0].volumeMounts[$i].mountPath}" po use-pv)
      echo "$mountpath"
      if [[ "$mountpath" == "/data" ]]
      then
        echo "Verification passed"
        return 0
      fi
     done
  else
    echo "Verification failed"
    return 1
  fi
  
}

verify_step

exit $?
