#!/bin/bash

# set -x # to test stderr output in /var/log/killercoda

echo starting... # to test stdout output in /var/log/killercoda

kubectl run  -n kube-system checker --image=alpine -- sleep infinity
kubectl wait -n kube-system  --for=condition=ready pod checker
kubectl exec -n kube-system checker -- apk add curl

echo "done" > /tmp/background0