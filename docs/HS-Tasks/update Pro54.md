

sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes-archive-keyring.gpg
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


- apt update
- apt-mark unhold cri-tools kubernetes-cni && apt-get update
- apt-get install -y cri-tools=1.34.0-1.1  kubernetes-cni=1.7.1-1.1 

> i had connection probles due to ipv6 so i ran:

```
 sudo apt-get -o Acquire::ForceIPv4=true update

and then:

 sudo apt-get -o Acquire::ForceIPv4=true install -y cri-tools=1.34.0-1.1 kubernetes-cni=1.7.1-1.1
```

- apt-mark hold cri-tools kubernetes-cni
-  apt-cache madison kubeadm
- Change the kubernetes service version on the servergroup at HS+. Then run puppet on the controlplane for the changes to apply.

- apt-mark unhold kubeadm 
- apt-get install -y kubeadm=1.34.1-1.1 --allow-change-held-packages && apt-mark hold kubeadm

- kubeadm upgrade plan  | 

do this in all cps before proceding. On the other cp intead of running upgrade plan you run `kubeadm upgrade node`



- kubectl drain controlplane1.staging.hs.srservers.net --ignore-daemonsets
- apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.30.6-1.1 kubectl=1.30.6-1.1 && apt-mark hold kubelet kubectl
- systemctl daemon-reload && systemctl restart kubelet
- kubectl uncordon controlplane1.staging.hs.srservers.net


#command to drain the workers

kubectl drain  worker1.staging.hs.srservers.net --ignore-daemonsets --delete-emptydir-data
