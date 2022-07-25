
### Les Volumes Persistants


Créez un `Persistent Volume` nommé `pv-analytics` qui contiendra `100Mi` de `stockage` dont l'acces sera en `ReadWriteMany`


- Nom du pv:  `pv-analytics`  
- Mode d'accès : `ReadWriteMany`
- Stockage:  `100Mi`
- Driver: HostPath sur `/pv/data-analytics`