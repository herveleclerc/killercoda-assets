# Challenge Hacker: L'Évasion et le Trésor Caché

Bienvenue, Hacker !

**Votre Situation :** Vous avez obtenu un accès shell initial dans un pod nommé `frontend-app-0` qui tourne dans un cluster Kubernetes. 

Ce pod semble peu intéressant à première vue.

- Vous savez que le `secret` est dans un répertoire /data
- Vous avez à disposition :
    - `curl`
    - `websocat`
    - `jq`
    - `openssl`

**Votre Mission :** Utilisez cet accès comme point de départ pour explorer l'environnement Kubernetes. 

Votre objectif est de découvrir des failles de configuration, d'escalader vos privilèges ou de trouver d'autres moyens d'accéder à des zones restreintes du cluster pour localiser et récupérer un "flag" secret (une chaîne de caractères au format `KUBE{...}`).



- **Attendez la fin de la configuration :** Le terminal affichera " Kubernetes environment ready.".

- **Cliquez** sur le bouton [**Start**] pour commmencer
