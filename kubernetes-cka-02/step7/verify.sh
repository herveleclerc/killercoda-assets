#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {

  if [ -f "/opt/.logs/give_up" ]; then
    echo "give_up file found, exiting"
    rm -f "/opt/.logs/give_up"
    echo "7:KO >> /opt/.logs/status.log"
    return 0
  fi
  
  ${kctl} run -n resolver test-resolver --rm -i --image=busybox:1.28 --restart=Never -- nslookup nginx-resolver-service > /opt/expected-nslookup-service.txt
  sed -i '$ d' /opt/expected-nslookup-service.txt

  if [[ ! -f /tmp/test-nslookup-service.txt ]]
  then
    echo "Verification failed"
    return 2
  fi


  diff '/opt/expected-nslookup-service.txt' '/tmp/test-nslookup-service.txt'
  if [[ $? -ne 0 ]]
  then
    echo "Verification failed"
    return 1
  else
    echo "Verification passed"
    echo "7:OK" >> "/opt/.logs/status.log"
    return 0
  fi
  
}

verify_step

exit $?
