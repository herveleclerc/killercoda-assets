#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
function verify_step() {
  
  hostname=$(hostname)

  ${kctl} run -n resolver test-resolver --rm -i --image=busybox:1.28 --restart=Never -- nslookup nginx-resolver-service > /opt/expected-nslookup-service.txt

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
    return 0
  fi
  
}

verify_step

exit $?