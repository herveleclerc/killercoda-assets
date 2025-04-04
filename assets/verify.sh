#!/bin/bash


EXPECTED_FLAG="KUBE{3sc4p3d_Th3_S4ndb0x_Successfully}"
FLAG_FILE="/tmp/flag.txt" # Chemin accessible depuis l'environnement Killercoda principal

# Vérifie si le fichier flag existe
if [[ -f "$FLAG_FILE" ]]; then
  # Lit le contenu du fichier
  SUBMITTED_FLAG=$(cat "$FLAG_FILE")

  # Compare le contenu avec le flag attendu
  if [[ "$SUBMITTED_FLAG" == "$EXPECTED_FLAG" ]]; then
    echo "done" # Signal de succès pour Killercoda
    exit 0
  else
    echo "Flag incorrect dans $FLAG_FILE." # Message pour l'utilisateur (optionnel)
    echo "pending" # Signal que ce n'est pas encore bon
    exit 1
  fi
else
  echo "Le fichier $FLAG_FILE n'a pas été trouvé." # Message pour l'utilisateur (optionnel)
  echo "pending" # Signal que ce n'est pas encore bon
  exit 1
fi