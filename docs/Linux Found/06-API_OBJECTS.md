# Objects
FUndamental building block that represent the various resources and components in the K8s system.
An API Object is a declarative configuration that describes the desired state of a k8s **resource**: Pod, Service, Namespace, Deployment.

Each API Object has generally 3 key sections:
- Metadata: objects name, namespace, annotations, labels
- Spec: Describes the desired state of the object. for example details to container images.The users specify the `spec`.
- Status: Kubernetes updates the status to reflect what is actually happening in the cluster.

So basically API Objects are the resources in Kubernetes that can be created, updated and managed via the K8s API

## v1 API Groups
this is a collection of groups for each main object category.

### 1. Node Object
Represent a machine that is part of the k8s cluster.
You can turn on and off the scheduling to a node with:

 - `kubectl get nodes`
 - `kubectl cordon/uncordon`

### 2. Service Account
API object that **provides an identity** to processes (containers within Pods) running inside the cluster.
This identity allows Pods to authenticate and make API requests to the Kubernetes cluster securely.
When a Pod is created, k8s assigns it a ServiceAccount
K8s mounts a **Secret** associated with that ServiceAccount into the Pod  as a token file.

It consists of:
- Secret Token
- Role Binding: "ClusterRoles"


### 3. Resource Quota
Define quotas per namespace (applied to namespaces). Limits resource consumption within a namespace and ensures fair resource distribution.
If you want to limit a specific namespace to only run a given number of pods, you can write a r**esourcequota** manifest, create it with **kubectl** and the quota will be enforced.

The resources that can be limited are:

- CPU
- Memory
- Persisten Storage
- Number of PVCs (Persistent volume claims)
- Objects counts: limiting the number of Pods, Services, Secrets, ConfigMaps objects in the namespace.

### 4. Endpoint
You dont manage endpoints. They represent the set of IPs and ports of the actual Pods that a Service routes traffic to. It maps the service name to the network locations.

If an endpoint is empty, then it means that there are no matching pods and something is wrong with the service definition.

## Deploying an Application
- `kubectl create`

When you deploy an application, several objects work together to ensure the app runs properly:

### Deploymet
Controller which manages the state of the ReplicaSets and the pods within.
Allows you to declare the desired state of your app.

When you create a *Deployment*, Kubernetes will automatically create the specified number of Pods

> Deployments manage **ReplicaSets** making sure the new versions of your app are deployed gradually and safely.

### ReplicaSet
Orchestrates individual pod lifecycle and updates. These are newer versions of Replication Controllers.
Ensures the desire number of Pods are running.

A ReplicaSet defines a **Pod template** that describes what each Pod should look like. This includes the container image, environment variables, volume mounts, etc and all pots using created by a ReplicaSet are identical based on thetemplate.

The **ReplicaSet** uses a Selector to identify which Pods it manages. This **selector**  includes labels.

### Pod
Lowest unit we can manage; it runs the application container.
In multi-container Pods, the containers typically share storage, network and configuration but are usually responsible for different aspects of the same task.

#### Pod Components
- Containers
- Networking and IP Address
- Storage
- Metadata
- Pod Templates


## DaemonSets
It is a CONTROLLER that ensures **pods of the same type** (a copy of the a Pod) run on **every node** in the cluster. When a new node is added to the cluster, a Pod, same as deployed on the other nodes, is started. **When the node is removed, the DaemonSet makes sure the local Pod is deleted.**
**When a pod (created by a DaemonSet) gets deleted, they will automatically restart.**
This is usefull for running background tasks like:
- Logging Daemons *fluentd*
- Monitoring agents to collect node metrics
- Networking agents like Calico
- Storage Daemons to provide node-local storage




## StatefulSet

Different to a Deployment is that StatefulSet needs **Service** that is gonna be exposing out Pods.

--------------------------------------

## Notes
k8s provides different APIs for running pods like Deployments(web-servers, proxy), statfulsets(db) and daemonsets.



so to understand deployments:
You have the pod node and inside the node you run the pods which will contain conteiners that run the application for example SQL.

SQL will not know that it runs on a container.
and is gonna write to the virtual filesystem of the container. This means any data written into the filesystem gets lost when the container gets destroyed.

With containers you normally solve this problem by mounting the path from the host (Node) into the container. This is called in Kubernetes  **PERSISTENT VOLUME** where even when the containers gets deleted, the data persist in the **node**


There are Internal peristent volume where the storage is done on the node and **External Persistent Volume** that we can attach to the node. so now if the node gets deleted then the data is safed externally.

This Volumes talk is needed to understand a bit what could be the difference between Deployments and Statefulset.
- A **deployment** would create pods, pods get created with a random hash as we know and this pods have shared volumes and by either scaling up or down is done also in a "random" manner.

- **Statefulset** will not create 3 nodes at once like deployment but will create them one by one. Each Pod will get its own **DNS name and a number!** different to what happens in Deployments.
- Also, if a pod get recreated it will get the same name and DNS so whatever application trying to reach this part of the cluster will be able to do it.
- Also when a statefulset deletes a pod, it retains the storage so if we recreate the pods again it will mount them to the same volumes they were attached to in the begining and therefore, no data loss will be happening.

### Stateless vs Statefull apps

#### Stateful
They allow to store, record. and return to already established information over the internet.
Here the server keeps track of the users session and keeps the information.

#### Stateless
Stateless applications dont save client session data on the server and rely on externalizes state data. They provide one service or function .


Stateless is the way to go if you need information in a transitory manner,quickly and temporarily. Is the app requires more memory of what happens from one session to the next.

This is used to manage stateful applications.

