# k8s cluster upgrades
On any node 
-  `kubectl drain controlplane1 --ignore-daemonsets --delete-emptydir-data --force`

Go to the first controlplane 
- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm='1.31.x-*'`
- `sudo apt-mark hold kubeadm`

Verify the version : `kubeadm version `
Verify the upgrade plan: `sudo kubeadm upgrade plan` this command checks that your cluster can be upgraded.

- this last command will give u the command to apply on the control plane: ` sudo kubeadm upgrade apply v1.31.x`

### ! MANUALLY UPGRADE YOUR CNI PROVIDER??!?!

### Upgrade kubelet and kubectl 
WE are still on the first controlplane

```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update
sudo apt-get install kubelet='1.31.x-*' kubectl='1.31.x-*'& \
sudo apt-mark hold kubelet kubectl
```

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

### Uncordon the node
Bring the node back online:
- `kubectl uncordon controlplane1`



## Additional control planes 
- `kubectl drain cp-2 --ignore-daemonsets --delete-emptydir-data --force`
cp2:
- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm='1.31.x-*'`
- `sudo apt-mark hold kubeadm`
- `sudo kubeadm ugrade node`


### Drain the node:
`kubectl drain <node-to-drain> --ignore-daemonsets` // this automatically cordons the node for you. 
**SO IT MARKS IT UNSCHEDULABLE**

### Upgrade kubelet and kubectl 

### Uncordon the node
Bring the node back online:
- `kubectl uncordon controlplane2`

## Upgrade worker nodes
- `kubectl drain worker-1 --ignore-daemonsets --delete-emptydir-data`
- `sudo apt-mark unhold kubeadm`
- `sudo apt-get update `
- `sudo apt install kubeadm='1.31.x-*'`
- `sudo apt-mark hold kubeadm`
- `sudo kubeadm upgrade node`

### Upgrade kubelet and kubectl 
## kubectl uncordon worker
