

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


- apt update
- apt-mark unhold cri-tools kubernetes-cni && apt-get update
- apt-get install -y cri-tools=1.30.1-1.1  kubernetes-cni=1.4.0-1.1
- apt-mark hold cri-tools kubernetes-cni
- apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.30.6-1.1 && apt-mark hold kubeadm
- kubeadm upgrade plan  | kubeadm upgrade node
- kubeadm upgrade apply v xxx


- kubectl drain controlplane3.staging.pro54.srservers.net --ignore-daemonsets
- apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.30.6-1.1 kubectl=1.30.6-1.1 && apt-mark hold kubelet kubectl
- systemctl daemon-reload && systemctl restart kubelet
- kubectl uncordon worker3.staging.pro54.srservers.net


#command to drain the
kubectl drain  worker3.staging.pro54.srservers.net --ignore-daemonsets --delete-emptydir-data