#!/bin/bash 


echo "Attention - Toute Sortie du pod 'frontend' est définitive !"

NAMESPACE="default"

kubectl exec -it $(kubectl get pods -n $NAMESPACE -l app=frontend -o jsonpath='{.items[0].metadata.name}') -- /bin/sh 
