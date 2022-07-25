
### Services et DNS

Créez un `pod` nommé `nginx-resolver` qui utilise l'image `nginx`.
Exposer le service en interne par la création d'un service nommé `nginx-resolver-service`. 
Montrez que vous pouvez accéder au service en utilisant le DNS. Enregistrer le résultat dans le fichier /tmp/test-nslookup.txt. 

Le check devra être fait par un pod nommé `test-nslookup` qui utilise l'image `busybox:1.28`.
Le pod devra faire un `nslookup` sur le service  et enregistrer le résultat dans le fichier `/tmp/test-nslookup-service.txt`.


- Nom du pod : `nginx-resolver`  
- Nom du service:  `nginx-resolver-service`  
- Namespace: `resolver`
  
- Commande : `nslookup`
  - Image pour le pod testeur : `busybox:1.28`