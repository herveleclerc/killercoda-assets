#!/bin/bash
#set -x # to test stderr output in /var/log/killercoda
echo starting... # to test stdout output in /var/log/killercoda

apt-get install -y etcd-client

openssl req -new -newkey rsa:4096 -nodes -keyout /root/alterway-key.pem -out /root/alterway-csr.pem -subj "/CN=alterway/O=devops"


kubectl apply -f /opt/.logs/pv-1.yaml
kubectl apply -f /opt/.logs/pvc-1.yaml -n default
echo done > /tmp/background0