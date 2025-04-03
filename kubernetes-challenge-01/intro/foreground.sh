#!/bin/bash
set +H

echo "Waiting for init-background-script to finish"
spinner="/-\|"
message="Init en cours...Veuillez patienter..."
delay=0.1

while [ ! -f /tmp/background0 ]; do 
  for i in $(seq 0 3); do
    printf "\r%s [%c] " "$message" "${spinner:$i:1}"
    sleep $delay
  done
done

echo "✅ Done"

echo "Bonjour et Bienvuenue sur le challenge recrutement n° 01 !"
