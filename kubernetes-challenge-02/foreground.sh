#!/bin/bash 


echo "Attention - Toute Sortie du pod 'frontend' est définitive !"

NAMESPACE="default"


sleep 20

kubectl exec -it frontend-app-0 -- /bin/sh 
