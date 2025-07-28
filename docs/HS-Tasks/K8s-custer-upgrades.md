# k8s cluster upgrades
# kubernetes
deb https://pkgs.k8s.io/core:/stable:/v1.30/deb/  /
deb [signed-by=/usr/share/keyrings/k8s-core-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /

# debian_backports
deb http://deb.debian.org/debian bullseye-backports main contrib non-free

- sudo apt-key del 234654DA9A296436
- `curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/k8s-core-archive-keyring.gpg`
 
sudo apt update
sudo apt-cache madison kubeadm


Go to the first controlplane 
- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm=1.31.11-1.1 `
- `sudo apt-mark hold kubeadm`

Verify the version : `kubeadm version `
Verify the upgrade plan: `sudo kubeadm upgrade plan` this command checks that your cluster can be upgraded.

- this last command will give u the command to apply on the control plane: ` sudo kubeadm upgrade apply v1.31.x`

### ! MANUALLY UPGRADE YOUR CNI PROVIDER??!?!

On any node 
-  `kubectl drain controlplane3.staging.hs.srservers.net  --ignore-daemonsets --delete-emptydir-data --force`

### Upgrade kubelet and kubectl 
WE are still on the first controlplane

```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update
sudo apt-get install kubelet=1.31.11-1.1 kubectl=1.31.11-1.1 & \
sudo apt-mark hold kubelet kubectl
```

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
```

### Uncordon the node
Bring the node back online:
- `kubectl uncordon controlplane1.staging.hs.srservers.net`



## Additional control planes 
cp2:
- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm=1.31.11-1.1`
- `sudo apt-mark hold kubeadm`
- `sudo kubeadm upgrade node`



### Drain the node:
`kubectl drain controlplane2.staging.hs.srservers.net --ignore-daemonsets` // this automatically cordons the node for you. 
**SO IT MARKS IT UNSCHEDULABLE**

### Upgrade kubelet and kubectl 

```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update
sudo apt-get install kubelet=1.31.11-1.1 kubectl=1.31.11-1.1 & \
sudo apt-mark hold kubelet kubectl
```

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
kubelet --version 
kubectl version
```

### Uncordon the node
Bring the node back online:
- `kubectl uncordon controlplane3.staging.hs.srservers.net`

## Upgrade worker nodes

- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm=1.31.11-1.1`
- `sudo apt-mark hold kubeadm`
- `sudo kubeadm upgrade node`

!!!!!

kubectl exec vault-1 -- vault operator unseal sKNVhNryRXQQuNkvX9yT81dd43DZ7P9Vt434xgT7V3c=

- `kubectl drain worker3.staging.hs.srservers.net   --ignore-daemonsets --delete-emptydir-data`


### Upgrade kubelet and kubectl 
```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update
sudo apt-get install kubelet=1.31.11-1.1 kubectl=1.31.11-1.1 & \
sudo apt-mark hold kubelet kubectl
```

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet
kubelet --version 
kubectl version
```

## kubectl uncordon worker

- `kubectl uncordon worker1.staging.hs.srservers.net`

## Troubleshooting 
Vault needs at least 2 pods running for the disruption budget.
We need to cordon worker1 and 2 then delete the pod and wait intil the pod is back and running again and then uncordon them again

If u cant runn kubectl locally u can enter other node and run it ther by exporting the admin.conf 
- `export KUBECONFIG=/etc/kubernetes/admin.conf`
- cordon /uncordon commands

