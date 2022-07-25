Parfait ! Vous avez fini Challenge n°1 de la certification CKA


## References 📚


---
# Solutions    
# 1

- kubectl run nginx-pod --image=nginx:alpine

# 2

- kubectl run messaging --image=redis:alpine  -l tier=msg

# 3 

- kubectl create ns cka-001

# 4 

- kubectl get nodes -o json > /tmp/nodes.json

# 5

- kubectl expose pod messaging --name messaging-service --port 6379

# 6 

- kubectl create deployment hr-web-app --image=kodekloud/webapp-color
  
- kubectl scale deployment hr-web-app --replicas=2   

# 7 

- kubectl run static-pod --image=busybox --command sleep 1000 --dry-run=client -o yaml > static-pod.yaml
  
- grep -i staticPod /var/lib/kubelet/config.yaml
  
- cp static-pod.yaml /etc/kubernetes/manifests/.
  
- kubectl get po

# 8

- kubectl create namespace finance

- kubectl run temp-bus -n finance --image=redis:alpine


# 9 
  - fixer le fichier yaml - remplacer sleeeeeep 3 par sleep 3 et relancer

# 10

- kubectl expose deploy hr-web-app --name hr-web-app-service --port 8080  --type NodePort --target-port 8080 


- kubectl patch svc hr-web-app-service --patch '{"spec": { "type": "NodePort", "ports": [ { "nodePort": 30082, "port": 8080, "protocol": "TCP", "targetPort": 8080 } ] } }'

# 11 

- kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /tmp/osImage.txt

# 12

- kubectl apply -f /opt/pv-analytics.yaml