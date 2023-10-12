set +x

echo "waiting for init-background-script to finish"
while [ ! -f /tmp/background0 ]; do sleep 1; done
echo "Bonjour et Bienvuenue sur Troubeshooting kubernetes 01 !"


read -p "Votre Prénom ? " PRENOM
read -p "Votre Nom ? " NOM
read -p "Votre email ? " EMAIL
read -p "Code de vérification ? " CODE

yq e -i ".nom=\"$NOM\"" ~/fin-challenge.json -o json
yq e -i ".prenom=\"$PRENOM\"" ~/fin-challenge.json -o json
yq e -i ".email=\"$EMAIL\"" ~/fin-challenge.json -o json
yq e -i ".code=\"$CODE\"" ~/fin-challenge.json -o json

