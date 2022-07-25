Parfait ! Vous avez fini Challenge n°1 de la certification CKA


## References 📚


---
# Solutions    
# 1

- ETCDCTL_API=3 etcdctl --endpoints=https://$(hostname -i | awk '{print $2;}'):2379 --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kubernetes/pki/etcd/healthcheck-client.key snapshot save /tmp/etcd-backup.db

# 2
<PRE>
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: elliphant
  name: elliphant
  namespace: default
spec:
  containers:
  - name: elliphant
    image: redis:alpine
    resources:
      requests:
        cpu: "1"
        memory: "200Mi"
EOF
</PRE>


# 3 

<PRE>
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: super-user-pod
  name: super-user-pod
  namespace: default
spec:
  containers:
  - name: super-user-pod
    image: busybox:1.28
    command: ["/bin/sh", "-c", "while true; do sleep 1; done"]
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
EOF
</PRE>
# 4 

<PRE>
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc-claim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 10Mi
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: use-pv
  name: use-pv
  namespace: default
spec:
  containers:
    - name: use-pv
      image: nginx
      volumeMounts:
      - mountPath: "/data"
        name: myvol
  volumes:
    - name: myvol
      persistentVolumeClaim:
        claimName: my-pvc-claim
EOF

</PRE>
# 5

<PRE>

kubectl create deploy nginx-deploy --image=nginx:1.17
kubectl set image deployment/nginx-deploy nginx=nginx:1.18
kubectl rollout status deploy nginx-deploy

</PRE>

# 6 

<PRE>
cat <<EOF> alterway-user.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: alterway-developer
spec:
  request: $(cat "/root/alterway-csr.pem" | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

kubectl create -f /root/alterway-user.yaml
kubectl get csr
kubectl certificate approve alterway-developer
kubectl get csr
kubectl create role developer -n development --verb=create,list,get,update,delete --resource=pods
kubectl create rolebinding developer-binding --role=developer --user=alterway --namespace=development
kubectl auth can-i create pods --as=alterway --namespace=development

</PRE>


# 7 


# 8

# 9 

# 10


# 11 


# 12
