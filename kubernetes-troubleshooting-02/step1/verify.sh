#!/bin/bash


export kctl="/usr/bin/kubectl --kubeconfig=/root/.kube/config"


function verify_step() {
    
    if [ -f "/opt/.logs/give_up" ]; then
        echo "give_up file found, exiting"
        rm -f "/opt/.logs/give_up"
        echo "1:KO >> /opt/.logs/status.log"
        ${kctl} delete --force --grace-period=0 -f ~/step1/step1.yaml
        return 0
    fi
    
    content=$(${kctl} get pods --no-headers --selector app=nginx  | grep nginx | awk '{print $3;}')
    
    if [[ "$content" == "Running"* ]]
    then
        
        failed=0
        
        # node-name node01
        node=$(${kctl} get pod --no-headers --selector app=nginx -o=custom-columns=NODE:.spec.nodeName)
        
        if [[ "$node" != "node01" ]]
        then
            failed=1
        fi
        
        # Check taints a here
        
        taints=$(${kctl} get nodes -o go-template='{{printf "%-50s %-12s\n" "Node" "Taint"}}{{- range .items}}{{- if $taint := (index .spec "taints") }}{{- .metadata.name }}{{ "\t" }}{{- range $taint }}{{- .key }}={{ .value }}:{{ .effect }}{{ "\t" }}{{- end }}{{- "\n" }}{{- end}}{{- end}}' | grep dedicated=front:NoSchedule| wc -l)
        
        if [[ "$taints" -ne 2 ]]
        then
            failed=1
        fi
        
        nodetype=$(${kctl} get pod --no-headers --selector app=nginx -o=custom-columns=NODE:.spec.nodeSelector.nodetype)
        
        if [[ "$nodetype" != "front" ]]
        then
            failed=1
        fi
        
        if [[ "$failed" -eq 0 ]];
        then
            echo "Verification passed"
            echo "1:OK" >> "/opt/.logs/status.log"
            return 0
        else
            echo "Verification failed"
            return 1
        fi
    else
        echo "Verification failed"
        return 1
    fi
}

verify_step

exit $?
