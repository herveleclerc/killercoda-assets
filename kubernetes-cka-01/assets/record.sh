#!/bin/bash

read -p "Votre Prénom ? " PRENOM
read -p "Votre Nom ? " NOM
read -p "Votre email ? " EMAIL
read -p "Code de vérification ? " CODE

yq e -i ".nom=\"$NOM\"" ~/fin-challenge.json -o json
yq e -i ".prenom=\"$PRENOM\"" ~/fin-challenge.json -o json
yq e -i ".email=\"$EMAIL\"" ~/fin-challenge.json -o json
yq e -i ".code=\"$CODE\"" ~/fin-challenge.json -o json


cat ~/fin-challenge.json

prenom=$(cat < "/root/fin-challenge.json" | jq -r '.prenom')
nom=$(cat < "/root/fin-challenge.json" | jq -r '.nom')
email=$(cat < "/root/fin-challenge.json" | jq -r '.email')
code=$(cat < "/root/fin-challenge.json" | jq -r '.code')


curl --fail -X POST -H 'Content-Type: application/json' \
--data "{\"channel\":\"aw-strongmind\",
\"icon_url\":\"https://assets.alterway.fr/2021/01/LOGO_STRONG_MIND.png\",
\"attachments\":[{\"title\":\"$prenom $nom ($email) tente le challenge k8s CKA #1 (killercoda)\",
\"title_link\":\"https://killercoda.com/hleclerc/scenario/kubernetes-troubleshooting-01\"}]}" \
https://mattermost.smile.fr/hooks/dhke1xbdy7g3bfwaxynb$code