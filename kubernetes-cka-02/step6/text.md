
### RBAC / users

Creéz un utilisateur nommé `alterway`. Donnez lui les droits suivant au niveau cluster.

- create, list, get, update, delete sur les pods dans le namespace `development`
- La cla privée et le csr sont disponible ici
  - /root/alterway-key.pem
  - /root/alterway-csr.pem 

- Nom de l'utilisateur: `alterway`   
- key : `/root/alterway-key.pem`  
- csr:  `/root/alterway-csr.pem`   
- Nom du CertificateSigningRequest: `alterway-developer` 
- Nom du role : `developer` 
- Namespace: `developer` 
- Nom du binding: `developer-binding`