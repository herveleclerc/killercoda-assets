
### Monter des volmes dans un pod

Vous avez a disposition le fichier /root/use-pv.yaml qui permet de créer un pod.
Utilisez ce manifeste en y ajoutant le montage d'un volume persistant appelé `pv-1`.
Assurez vous que le pod fonctionne.

- Point de Montage:  `/data`  
- Nom du Persistent Volume Claim : `my-pvc-claim`
- Fichier:  `/root/use-pv.yaml`
