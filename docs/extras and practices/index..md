# Kubernetes
## Kubernetes Cluster
A k8s deployment is called a cluster which is a group of hosts running Linux containers (NODES). and it can be divided in **control plane** and the **compute machines or nodes**.

<span style="color:mediumslateblue;">**Control plane**</span>
It can be one or more control plane nodes (which are called replicas).
It manages the state of the cluster.
There is only one control plane per kubernetes cluster.
In production environments, the **Control plane can run in multiple nodes** that can span across several data centers or servers
    - kube-apiserver
    - kube-scheduler
    - kube-controller-manager
    - etcd

<span style="color:mediumslateblue;">**Nodes** or **Worker Nodes** (computer machines).</span>
- If we have 3 servers, we have 3 nodes, we have 3 workers.
This workers run the containerized applications that run in a POD.
    - kubelet (service that makes sure each container is running)
    - kube-proxy
    Pods (pods are made up containers)

 Nodes can be either physical or virtual machines
 Each node runs pods which can have one or more containers that run the apps and are created and managed by the Control plane.
 A single pod provides shared storage and networking
 They take the commands/ as instructions from the **control plane** which mantains the desire state of the cluster.


## <span style="color:mediumslateblue;"> Control Plane Components </span>
### API-Server
Submits the request to manage the cluster.
Is the way to communicate with the k8s cluster.

### etcd
 Stores and retrievesinfo about the cluster's persistent state.
 Stores the key-values

### Scheduler
Checks the resources required by the pod and decides in which worker is gonna be placed according to this.

## <span style="color:mediumslateblue;">Nodes </span>

### kubelet
Daemon that recieves instructions from the control plane about what pods to run on the node and mantains the desired state of the pod according to the instructions of the control plane

### kube-proxy
Networking Proxy, routes traffic to the correct pods, does loadbalancing for the pods.
### container runtime

Runs the containers, pulls the containers images from the registry, starts and stops the containers and manage their resources.

## K8s vs Docker
In the node, Docker can run as a container runtime.
K8s schedules a pod to a node, kublet on this node will instruct then Docker to launch the **specified containers.**

So Docker would pull containers onto the NODE.
The difference when using K8s is that the collection of info from the containers is done by an automated system insted of having the admin doing this manually on all nodes for all containers.

## K8s Use
Kubernetes containers can be schedule across a cluster. This microsercives in containers make it easier to orchestrate services, including storage, networking and security.

Kubernetes sorts containers into pods. <span style="color:mediumslateblue;">Pods</span> add a layer of abstraction to grouped containers, which hekps schedule <span style="color:mediumslateblue;">workloads/Pods</span> and provide necessary services-like networking and storage-to those containers.


Kubernetes manages sensitive data and connfiguration detailsfor an application separately from the container image.



---------------------------

## Terminology
### Namespaces
In K8s a namespace is the working area or your project.
If multiple users and teams user the same K8s cluster we can <span style="color:mediumslateblue;">partition the cluster into virtual sub-clusters using **Namespaces**
</span>. Objects created *inside* a Namespace are UNIQUE but NOT *across* Namespaces in the cluster.


<span style="color:mediumslateblue;"> - list ns: `kubectl get namespaces`</span>


K8s creates by default the following namespaces:

1. **default:** contains objects that, when created, had no other namespaces provided.

2. **kube-system:** objects created by the k8s system.

3. **kube-public:** Insecure, readable object for exposing info about the cluster.


<span style="color:mediumslateblue;"> - create ns: `kubectl create namespaces <ns-name>`</span>




### Pods
Unit of work and way to interconnect the containers on them. If you update one, it becomes version 2 and and version one is taken out.

Each container on the same Pod has access to the same external storage (volumes).


```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    run: nginx-pod
spec:
  containers:
  - name: nginx-pod
    image: nginx:1.22.1
    ports:
    - containerPort: 80   // TCP ports are the default

```

> **Kind:** Specifies the Pod object type

> **Metadata:** holds the name and optional annotations.

> **Spec:** marks the beginning of the block defining the desire state of the Pod object

*This Pod is creating a single container from the nginx:1.22.1 image*


### Service
Is a method for exposing a network application that is running as one or more Pods in a cluster. So you use a Service to make that set of Pods available on the network so that clients can interact with it.

A service also defines a logical set of pods and sets a policy about who can acces them.

### Ingress
Works with the service to make sure everything ends up in the right place. It also provides load balancing.

### Secrets
An Object and a place to store confidential information.

### Container Orchestration
Group systems together to form clusters.
The containers in a cluster can communicate with each other regarthless of the host they are deployed to in the cluster.

