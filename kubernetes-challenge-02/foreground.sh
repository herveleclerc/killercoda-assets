#!/bin/bash 


echo "Attention - Toute Sortie du pod 'frontend' est définitive !"

NAMESPACE="default"

kubectl exec -it frontend-app-0 -- /bin/sh 
