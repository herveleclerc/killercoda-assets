# Challenge Hacker: L'Évasion et le Trésor Caché

Bienvenue, challenger !

**Votre Situation :** Vous avez obtenu un accès shell initial dans un pod nommé `frontend-app` qui tourne dans un cluster Kubernetes. Ce pod semble peu intéressant à première vue.

**Votre Mission :** Utilisez cet accès comme point de départ pour explorer l'environnement Kubernetes. Votre objectif est de découvrir des failles de configuration, d'escalader vos privilèges ou de trouver d'autres moyens d'accéder à des zones restreintes du cluster pour localiser et récupérer un "flag" secret (une chaîne de caractères au format `KUBE{...}`).

**Premiers Pas :**

1.  **Attendez la fin de la configuration :** Le terminal affichera " Kubernetes environment ready." lorsque vous pourrez commencer.
2.  **Obtenez un shell dans le pod cible :**
    *   Listez les pods pour trouver le nom exact du pod `frontend-app` (il aura un suffixe aléatoire) :
        ```bash
        kubectl get pods
        ```
    *   Exécutez la commande suivante en remplaçant `<nom-du-pod-frontend>` par le nom complet trouvé :
        ```bash
        # Remplacez <nom-du-pod-frontend> ci-dessous !
        kubectl exec -it <nom-du-pod-frontend> -- sh
        ```
3.  **Commencez votre exploration :** Une fois dans le shell du pod `frontend-app`, examinez votre environnement. Pensez notamment à :
    *   Où se trouve le token du Service Account ? (`/var/run/secrets/kubernetes.io/serviceaccount/`)
    *   Quels outils sont disponibles dans le pod ? (`kubectl`? `curl`?)
    *   Quelles permissions ce token vous donne-t-il sur l'API Kubernetes ?

**Comment Valider le Challenge :**

Une fois que vous avez trouvé le flag (qui ressemble à `KUBE{...}`), créez un fichier `/opt/flag.txt` (depuis le terminal *principal* de Killercoda, pas depuis l'intérieur du pod `exec`) contenant **uniquement** le flag :

```bash
# Exécutez ceci dans le terminal principal de Killercoda, PAS dans le shell du pod exec !
echo "KUBE{votre_flag_trouve}" > /opt/flag.txt
```


