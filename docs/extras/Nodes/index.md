# All about Nodes
In a multi-worker Kubernetes cluster, the network traffic between client users and containerized applications deployed in Pods is handled directly by the worker nodes and is NOT routed through the control plane node.

<span style="color:mediumslateblue;"> Each node is managed with the help of **kubelet** and **kube-proxy** which execute workload management tasks.</span>

## kubelet
It communicates with the control plane. It recieves Pod definitions and interacts with the container runtime to run the containers associated with the Pod, this interaction is done through the plugin CRI.

**CRI** implements 2 services:

**ImageService** - responsible for all the image-related operations.

**RunntimeService** - responsible for all the Pod and container operations.

## kube-proxy
Responsible of all networking rules on the node as well as for TCP, UDP and SCTP stream forwarding or random forwarding.
It works in conjunction with the iptables of the node.