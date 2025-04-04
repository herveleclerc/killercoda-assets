# Challenge Hacker: L'Évasion et le Trésor Caché

## Le Challenge

**Premiers Pas :**

1.  **Obtenez un shell dans le pod cible :**
    *   Listez les pods pour trouver le nom exact du pod `frontend-app-0` :
        ```bash
        kubectl get pods
        ```
    *   Exécutez la commande suivante :
        ```bash
        kubectl exec -it frontend-app-0 -- sh
        ```
2.  **Commencez votre exploration :** Une fois dans le shell du pod `frontend-app-0`, examinez votre environnement. Pensez notamment à : 
    *   Quels outils sont disponibles dans le pod ? (`kubectl`? `curl`?)

**Comment Valider le Challenge :**

Une fois que vous avez trouvé le flag (qui ressemble à `KUBE{...}`), créez un fichier `/tmp/flag.txt` (depuis le terminal *principal* de Killercoda, pas depuis l'intérieur du pod `exec`) contenant **uniquement** le flag :

```bash
# Exécutez ceci dans le terminal principal de Killercoda, PAS dans le shell du pod exec !
echo "KUBE{votre_flag_trouve}" > /tmp/flag.txt
```

**Bon courage !**