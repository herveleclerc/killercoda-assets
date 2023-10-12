


### Étape 2 - Déployez le manifeste suivant
```
kubectl apply -f ~/step2/step2.yaml -n default
```{{exec}}

- Corriger le fichier  ~/step2/step2.yaml
- Appliquer vos modifications
- Vérifier en cliquant sur le bouton **Check**

Note : Vérifiez bien que vos modifications soient bien appliquer en utilisant les commandes de base via kubectl 

Hints : 

- Déploiements

`kubectl get deploy  -n default`{{exec}}

- Pods

`kubectl get po  -n default`{{exec}}
