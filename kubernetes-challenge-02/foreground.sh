#!/bin/bash 


echo "Attention - Toute Sortie du pod 'frontend' est définitive !"

NAMESPACE="default"

kubectl exec -it $(kubectl get pods -n $NAMESPACE -l app=frontend) -- /bin/sh 
