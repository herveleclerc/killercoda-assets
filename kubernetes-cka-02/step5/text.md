
### Mise à jour des déploiments

Créez un déploiemnt nommé `nginx-deploy` avec `1 replicas` et qui utilise l'image `nginx:1.17`.

Puis faire un upgrade de la version de l'image `nginx:1.17` à `nginx:1.18` en utilisant la méthode de "rolling update". 

- Nom du deployment:  `nginx-deploy`  
- Image avant update : `nginx:1.17`
- Image après update : `nginx:1.18`
- Namespace: `default`
- Replicas: `1`

