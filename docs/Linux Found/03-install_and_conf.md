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

### Dig Deeper TriniD!
- [CNI, k8s networking explained, Calico0](https://www.tigera.io/learn/guides/kubernetes-networking/kubernetes-cni/#:~:text=CNI%20was%20created%20to%20make,networking%20and%20container%20execution%20layers.)

