#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

  
function verify_step() {
  if [ -f "/tmp/etcd-backup.db" ]
  then
    content=$(${ectl} snapshot status /tmp/etcd-backup.db -w json | grep -c "hash.*revision.*totalKey.*totalSize")
    if [[ "$content" == "1" ]]
    then
      echo "Verification passed"
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
