
### Suis je en vie ?


Créez le namespace `healthchecking` et créez un pod nommé `cka-nginx-1` dans ce namespace avec le conteneur suivant `nginx:alpine`.
Ce pod devra avoir une sonde de `liveness http` sur le port `80`, s'executant toutes les `5 secondes` avec un delais initial de `3 secondes`.

Un fois le pod créé et en fonctionnement supprimez le fichier `/usr/share/nginx/html/index.html` à l'intérieur du pod.

Copiez dans le fichier `/tmp/healthchecking.txt` le **Message** de ligne montrant que la sonde est en échec (ligne avec le code d'erreur http)

Hint: Commence par `Liveness...`


- Nom du pod : `cka-nginx-1`   
- Namespace: `healthchecking`
- Image: `nginx:alpine`
- Nom du fichier à supprimer : `/usr/share/nginx/html/index.html`
