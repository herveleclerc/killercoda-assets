#!/bin/bash

# set -x # to test stderr output in /var/log/killercoda

echo starting... # to test stdout output in /var/log/killercoda

kubectl apply -f /root/backend-deployment.yaml
kubectl apply -f /root/backend-service.yaml
kubectl apply -f /root/backend-netpol-broken.yaml
kubectl apply -f /root/frontend-deployment.yaml

rm -f /root/backend-deployment.yaml
rm -f /root/backend-service.yaml
rm -f /root/backend-netpol-broken.yaml
rm -f /root/frontend-deployment.yaml

echo "done" > /tmp/background0