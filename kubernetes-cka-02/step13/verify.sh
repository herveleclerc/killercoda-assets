#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"
  
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
          
          result=$(grep -c OK /opt/.logs/status.log)
          p=$(bc <<<"$result*100/12")
          if [[ $p -ge 80 ]]; then
            msg="Réussite"
          else
            msg="Échec"
          fi

          curl --fail -X POST -H 'Content-Type: application/json' \
            --data "{\"alias\":\"strongmind\",
            \"emoji\":\":strongmind:\",
             \"text\":\"Challenge cka-001\",
            \"attachments\":[{\"title\":\"Passage du Challenge cka-002 (killercoda) avec un score de $p%\",
            \"title_link\":\"https://killercoda.com/hleclerc/scenario/kubernetes-cka-02\",\"text\":\"$prenom $nom ($email)  a passé la certification cka-002 avec un résultat de $p% ($msg)\",\"color\":\"#764FA5\"}]}" \
            https://rocket.alterway.fr/hooks/QxnH7sqdQwLeby5vP/E5KwEWg88cT8RHrJJifYzdG5wfL5RPySPzKwMxZp$code
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
