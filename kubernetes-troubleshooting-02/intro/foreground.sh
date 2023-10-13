set +x
{ echo "Waiting for init-background-script to finish"; } 2> /dev/null
while [ ! -f /tmp/background0 ]; do sleep 1; done
{ echo "Bonjour et Bienvuenue sur Troubeshooting kubernetes 02 !"; } 2> /dev/null
