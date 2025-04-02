#!/bin/bash
set +H

echo "Waiting for init-background-script to finish"

while [ ! -f /tmp/background0 ]; do sleep 1; done

echo "✅ Done"

echo "Bonjour et Bienvuenue sur le challenge recrutement n° 01 !"
