# Networking K8s
## Context for Dummies
In k8s the term "localhost" refers to the network address '127.0.0.1" which is a loopback address used by a machine to refer to itself.



## Container-to-Container communication inside Pods
A container runtime creates an isolated network space for each container it starts. This isolated network is referred to as a **network namespace** and means that the containers share the same IP address and network interfaces.

The network works as one for the Pod and all containers in the same pod will be able to talk to each other via localhost. Containers coordinate ports assignment inside the pod jsut as applications would on a VM.

## Pod-to-Pod communication on the same node and across cluster nodes

Pods are expected to be able to communicate with all **other Pods in the cluster**.

Kubernetes network model aims to reduce complexity and it treats **Pods as VM's** on a network where each VM is equipped with a network interface, that is why each Pod has a unique IP address. This is called "IP-per-Pod".

> When a container inside a pod refers to "localhost" it is addressing the ***network interface of the pod*** itself.

> For this reason, if one container is running a web server on port 8080, another container IN THE SAME POD can access it via `localhost:8080`.


## External-to-Service communication for clients to access applications in a cluster

In order for containerized apps to get access to the external world Kubernetes enables **Services**.

A service provides a stable endpoint (IP and DNS name) to access a **group of pods**. The service encapsulate routing rules, in iptables on **cluster nodes** and are implemented by **kube-proxy** so applications become accessible over a virtual IP and a dedicated port number.
