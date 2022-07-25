Parfait ! Vous avez fini Challenge n°1 de la certification CKA


## References 📚


---
# Solutions    
# 1

```bash
kubectl run nginx-pod --image=nginx:alpine
```

# 2

```bash
kubectl run messaging --image=redis:alpine  -l tier=msg
```

# 3 

```bash
kubectl create ns cka-001
```

# 4 

```bash
kubectl get nodes -o json > /tmp/nodes.json
```

# 5

```bash
kubectl expose pod messaging --name messaging-service --port 6379
```

# 6 

```bash
kubectl create deployment hr-web-app --image=kodekloud/webapp-color
```

```bash
kubectl scale deployment hr-web-app --replicas=2   
```

# 7 

```bash
kubectl run static-pod --image=busybox --command sleep 1000 --dry-run=client -o yaml > static-pod.yaml
```

```bash
grep -i staticPod /var/lib/kubelet/config.yaml
```

```bash
cp static-pod.yaml /etc/kubernetes/manifests/.
```

```bash
kubectl get po
```

# 8

```bash
kubectl create namespace finance
```

```bash
kubectl run temp-bus -n finance --image=redis:alpine
```

# 9 
  ```bash
fixer le fichier yaml ```bash
remplacer sleeeeeep 3 par sleep 3 et relancer
```

# 10

```bash
kubectl expose deploy hr-web-app --name hr-web-app-service --port 8080  --type NodePort --target-port 8080 
```


```bash
kubectl patch svc hr-web-app-service --patch '{"spec": { "type": "NodePort", "ports": [ { "nodePort": 30082, "port": 8080, "protocol": "TCP", "targetPort": 8080 } ] } }'
```

# 11 

```bash
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /tmp/osImage.txt
```

# 12

```bash
kubectl apply -f /opt/pv-analytics.yaml
```

# 13 

Suivre les instructions