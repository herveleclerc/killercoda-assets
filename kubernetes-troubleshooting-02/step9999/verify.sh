#!/bin/bash

export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"

NUM_STEP="1"
  
function verify_step() {
  
if [ -f "/root/fin-challenge.json" ]; then
     prenom=$(cat < "/root/fin-challenge.json" | jq -r '.prenom')
     nom=$(cat < "/root/fin-challenge.json" | jq -r '.nom')
     email=$(cat < "/root/fin-challenge.json" | jq -r '.email')
     code=$(cat < "/root/fin-challenge.json" | jq -r '.code')
     if [[ -z "$prenom" ]]  ||  [[ -z "$nom" ]] || [[ -z "$code" ]] || [[ -z "$email" ]]
     then
       echo "Verification failed"
       return 1
     else
       if [[ "$prenom" != "CHANGEZ-MOI" && "$nom" != "CHANGEZ-MOI" && "$code" != "CHANGEZ-MOI"  && "$email" != "CHANGEZ-MOI" ]]; then

          result=$(grep OK /opt/.logs/status.log | sort -u | wc -l)

          if [[ $result -eq 0 ]]; then 
             msg="Échec"
             emo="☔️☔️☔️☔️☔️"
             p=0
          else
            p=$(bc <<<"$result*100/$NUM_STEP")
            if [[ $p -ge 80 ]]; then
              msg="Réussite"
              emo="✨"
            else
              msg="Échec"
              emo="☔️"
            fi
          fi 

          curl --fail -X POST -H 'Content-Type: application/json' \
            --data "{\"channel\":\"aw-strongmind\",
            \"emoji\":\":strongmind:\",
             \"icon_url\":\"https://assets.alterway.fr/2021/01/LOGO_STRONG_MIND.png\",
            \"attachments\":[{\"title\":\"$emo $msg pour $prenom $nom ($email) sur le test k8s troubleshooting #2 (killercoda) avec un score de $p%\",
            \"title_link\":\"https://killercoda.com/hleclerc/scenario/kubernetes-troubleshooting-01\"}]}" \
            https://mattermost.smile.fr/hooks/dhke1xbdy7g3bfwaxynb$code
            retVal=$?
            if [ $retVal -ne 0 ]
            then
              echo "Verification failed"
              return 1
            else
              echo "Verification passed"
              rm -f /root/fin-challenge.json
              return 0
            fi
        else
          echo "Verification failed"
          return 1
        fi
     fi
else
  return 1
fi
  
}

verify_step

exit $?

