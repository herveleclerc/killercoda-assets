#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"


function verify_step() {
    
    if [ -f "/opt/.logs/give_up" ]; then
        echo "give_up file found, exiting"
        rm -f "/opt/.logs/give_up"
        echo "3:KO >> /opt/.logs/status.log"
        ${kctl} delete --force --grace-period=0 -f ~/step3/step3.yaml
        return 0
    fi
    
    content=$(${kctl} get pods --no-headers --selector app=nginx-step3  | grep nginx | awk '{print $3;}')
    
    if [[ "$content" == "Running"* ]]
    then
        echo "Verification passed"
        echo "3:OK" >> "/opt/.logs/status.log"
        ${kctl} delete --force --grace-period=0 -f ~/step3/step3.yaml
        return 0
    else
        echo "Verification failed"
        return 1
    fi
}

verify_step

exit $?
