
### Gérer les quotas de resources

Créez un namespace nommé `cka-ressources`. Définissez un quota de resources pour ce namespace ayant les limites et requests (hard) suivantes:

- requests memory: `1G`
- limits memory: `2G`

Créez un pod nommé `cka-pod-1` dans le namespace `cka-ressources` avec le conteneurs suivant `redis:alpine`.
Le manifeste du pod devra être écrit en yaml.

Affectez les `requests` et `limits` suivantes au pod :

- requests memory: `1.5G`
- request cpu: `250m`
- limits memory: `2G`

Vous devez écrire le manifeste du pod dans le fichier `/root/pod-over-request.yaml`


Copiez la sortie résultant de la commande `kubectl apply -f /root/pod-over-request.yaml` dans le fichier `/tmp/pod-over-request.txt`

Hint: la sortie doit commencer par `Error from server (Forbidden): error when creating "/root/pod-over-request.yaml": pods "cka-pod-1" is forbidden:` ...


- Nom du quota: `cka-ressources`
- Nom du pod : `cka-pod-1`     
- Namespace: `cka-ressources`   


   
