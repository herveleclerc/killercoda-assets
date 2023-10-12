# set -x # to test stderr output in /var/log/killercoda

echo starting... # to test stdout output in /var/log/killercoda


(
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
)


export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/.bashrc

source $HOME/.bashrc

kubectl krew install neat

kubectl run  -n kube-system checker --image=alpine -- sleep infinity
kubectl wait -n kube-system  --for=condition=ready pod checker
kubectl exec -n kube-system checker -- apk add curl

kubectl taint nodes node01 dedicated=front:NoSchedule
kubectl taint nodes controlplane dedicated=front:NoSchedule
kubectl cordon controlplane
kubectl cordon node01



echo "done" > /tmp/background0