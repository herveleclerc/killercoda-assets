#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
export ETCDCTL_API=3
export ectl="etcdctl --endpoints=https://$(hostname -i | awk '{print $1;}'):2379 --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key"


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
