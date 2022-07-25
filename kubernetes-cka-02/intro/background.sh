#!/bin/bash
#set -x # to test stderr output in /var/log/killercoda
echo starting... # to test stdout output in /var/log/killercoda
apt-get install -y etcd-client
kubectl apply -f /opt/.logs/pv-1.yaml
kubectl apply -f /opt/.logs/pvc-1.yaml -n default
echo done > /tmp/background0