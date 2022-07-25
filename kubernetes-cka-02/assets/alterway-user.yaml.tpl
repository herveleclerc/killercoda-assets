apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: alterway-developer
spec:
  request: $(cat /root/alterway-csr.pem | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
