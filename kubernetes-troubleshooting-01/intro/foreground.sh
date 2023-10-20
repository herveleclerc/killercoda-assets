#!/bin/bash
set +H

echo "Waiting for init-background-script to finish"

while [ ! -f /tmp/background0 ]; do sleep 1; done

printf "✅ Done \n"

echo "Bonjour et Bienvuenue sur Troubeshooting kubernetes 01 !"
