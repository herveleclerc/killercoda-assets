


### Étape 4 - Déployez le manifeste suivants
```
kubectl apply -f ~/step4/step4.yaml -n default
```{{exec}}

- Corriger le fichier  ~/step4/step4.yaml
- Appliquer vos modifications
- Vérifier en cliquant sur le bouton **Check**

Note : Vérifiez bien que vos modifications soient bien appliquer en utilisant les commandes de base via kubectl 

Hints : 

- Déploiements

`kubectl get deploy  -n default`{{exec}}

- Pods

`kubectl get po  -n default`{{exec}}
