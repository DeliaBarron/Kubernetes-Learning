# 03 Installation and Configuration
## kubeadm and installation
`kubeadm` is a tool used to deploy a kubernetes cluster.
- `kubeadm init`: you run on a control plane node
- `kubeadm join`: tha run on your worker nodes
This bootstraps the cluster.

If you do a `kubeadm -h` you will get a bit of information on the process of creating a new k8s cluster.

> For further understanding of the fundamentals of Kubernetes and how the core components fit together, take a look at the **[Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way.git)** which guides you through bootstrapping a basic Kubernetes cluster with all control plane components running on a single node, and two worker nodes, which is enough to learn the core concepts.

## Installation considerations
With *systemd*  from Linux, Kubernetes componetns will end up being run as *systemd unit files* or via *kubelet* running on the head node.



## Installing a Pod Network
Several containers runtimes currently use **Container Network Interface** (CNI).
It defines a common interface for bpth the networking and the container execution layers.

**[CNI videos](https://www.youtube.com/results?search_query=container+network+interface)**

**- Calico:** CNI plugin provides networking for containers. It handles the creation of Virtual network interfaces **for pods** and connects them to the network following the CNI standard. It routes PODS across NODES. This is done thorugh standard routing protocols like BGP (Border Gateway Protocol) whichs collects routing information to choose the best peering option. (peering option means the best, closest network to be chosen. This enables communication between networks).

### Lab Notes
#### 3.1-3.3
When applying the cilium yaml file in my delia-cka namespace I got the error that the namespace was not matching with the one in the file as I ran a kubectl apply --namespace delia-cka and in the yaml it had specified kube-system as a namespaces so ,I had to first go to the yaml file, select all namespaces key and change it to have the value `delia-cka`, then i could run the `kubectl apply -f /home/dsanchez/LFS458/SOLUTIONS/s_03/cilium-cni.yaml --namespace delia-cka`.

#### 3.4
**Deploy a simple application**

- `kubectl create deployment nginx --image:nginx`
- `kubectl describe deployment nginx`: summarized overview and events logs.
- `kubectl get desployment -o yaml`: retrieves the exact state of the deployment in YAML format.
- `kubectl create deployment two --image=nginx --dry-run=client -o yaml`: the dry-run flag shows what would happen without having it actually happen.

**Create a sever**
- `kubectl expose -h`: command to expose a **resource** as a service.
Some of this services are: pod, service(svc), replicationcotroller (rc), deployment(deploy), replicaset (rs).
The **kubectl expose** command uses the selector for that resource as the selector for a new service on the specified port.

**Change an object configuration**
The apply command makes a 3-way diff of previous, current and supplied to make the changes.
If a resource field can't be updated you can apply disruptively with : `replace --force` Which will delete and then re-create a resource.

**Expose a service**
- `kubectl expose deployment/nginx`
This will act as a stable endpoint for accessing the `nginx` pods.

- `kubectl get svc nginx` : this will show you the `ClusterIP` that this pod got when becoming a service.

ClusterIP: this is the IP or DNS provided by k8s within the Kubernetes cluster. When you access the service through the `ClusterIP` the service uses loadbalancing to redirect traffic among the pods inside the cluster that are available.

If a client or another Pod within the same Kubernetes cluster wants to access the application, it can use the Service’s ClusterIP and port.


So the service would recive the request and forward it to one of the `Endpoints` (pods  IP). SO the service acts like a proxy that routes tracffic to Pods.



### Dig Deeper TriniD!
- [CNI, k8s networking explained, Calico0](https://www.tigera.io/learn/guides/kubernetes-networking/kubernetes-cni/#:~:text=CNI%20was%20created%20to%20make,networking%20and%20container%20execution%20layers.)

