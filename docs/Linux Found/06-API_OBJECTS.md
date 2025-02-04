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

When you create a *Deployment*, Kubernetes will automatically create the specified number of Pods.

> Deployments manage **ReplicaSets** making sure the new versions of your app are deployed gradually and safely.

### ReplicaSet
Orchestrates individual pod lifecycle and updates. These are newer versions of Replication Controllers.
Ensures the desire number of Pods are running.

A ReplicaSet defines a **Pod template** that describes what each Pod should look like. This includes the container image, environment variables, volume mounts, etc and all pots using created by a ReplicaSet are identical based on thetemplate.

The **ReplicaSet** uses a Selector to identify which Pods it manages. This **selector**  includes labels.

When would you use a `replicaSet` directly instead of a Deployment? As they dont handle updated like deployments do, you would use a `replicaSet`
- **if you dont need to update software**
- **If you need custom update behaviour that wont work with deployments as the manage pods in bigger scale**

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

DaemonSets Pods are gonna get deployed by K8s even when theres toleration problems as DaemonSet Pods are more critical than those of StatefulSet or Deployment.

**To communicate to the DaemonSets Pods**

- By using a `ClusterIP` service which allows to select pods through **label selector** and use the service to reach a daeomn on a random node. (No way to reach specific node)

- DNS: Create a `headless service` and using the endpoints resource or retrieve multiple A records from DNS.

- NodeIP and Known Port: Pods in the DaemonSet can use a `hostPort`, so that the pods are reachable via the node IPs. Clients know the list.



## StatefulSet

Different to a Deployment is that StatefulSet needs **Service** that is gonna be exposing out Pods.

## Autoscaling
In K8s there is **HPA** (Horizontal Pod Autoscalers)
Automatically increases or decreases the number of Pods in response to the current demand of resources.

It can be applied to:
- Deployments
- ReplicaSets
- StatefulSets

HPA checks on the metrics which are retrieved every 15 sec. If the CPU usage increases for ex. Then HPA will increase the number of pods to handle the increased load.


## Jobs
Jobs are in the **batch** group
They are used to run a set number of pods to completion.
if a pod fails, it will be restarted until the number of completions is reached.

Contrary to a `CronJob` a `Job` is not scheduled. It will run when you run it and terminate when the task is done.  "just once or on demand."

A `CronJob` is to run **recurring tasks** that are schedule. "Use a CronJob for tasks that need to run repeatedly on a schedule."

Batch Kobs are often used for operations or processes that can run async. in the background.
They are **Non-Interactive** which means the run independently without requiring user intervention during execution.

> Jobs and CronJobs belong to the `batch` API group.

### Work with Jobs
- create a Job object

```
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    spec:
      containers:
        - name: hello-world
          image: busybox
          command: ["echo", "Hello, World!"]   # Ensures the pod does not restart if it completes or fails
      restartPolicy: Never                      # Number of retries if the Job fails
```

- `kubectl apply -f job.yaml`

- `kubectl get pods`

- `kubectl logs <pod-name>`: to see the output of the job in that pod.


## RBAC
RBAC are in the **rbac.authorization.k8s.io** group.
 This group has 4 Objects:

- ClusterRole
- Role
- ClusterRoleBinding
- RoleBinding




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



## Lab 6.1

- Get the node and port where the api is listening

`k config view` | grep server
> server: https://api.staging.pro54.k8s.hundertserver.com:443


- crate a token secret

`export token=$(kubectl create token default)`

- Access the api using curl and passing the token

`curl https://api.staging.pro54.k8s.hundertserver.com:443/apis --header "Authorization: Bearer $token" -k`

**-k** to avoid using a cert

- acces v1 api
`curl https://api.staging.pro54.k8s.hundertserver.com:443/api/v1 --header "Authorization: Bearer $token" -k`


## Lab 6.2 proxy
You can set a proxy on a sidecontainer that interacts with the k8s API.

- A proxy is an intermediary between the client (the one that does the curl) and the k8s API. Forwarding request from the client to the API server.

- This way you dont have to both know and hardcode the api ip and you also dont need to handle the authentication tokens yourself.

- The proxy typically uses the Service Account token mounted into the Pod automatically, removing the need for you to manually include an authentication header.

- Using a proxy you would access the API server via the proxy at http://127.0.0.1:8001, which is portable and consistent.

- The proxy hides the API server's actual endpoint, reducing the risk of exposing sensitive information.

- `kubectl proxy -h`

Start the proxy while setting the API prefix AND put it in the background. This will start a proxy TEMPORARILY until you close the terminal or kill the proceess.

- `kubectl proxy --api-prefix=/ &`

 Now use the same **curl** command, but point toward the IP and port shown by the proxy command before.

 - `curl http://127.0.0.1:8001/api/`


Stop the proxy service as we dont need it anymore (remember it was running on the background). Use the process ID to kill it. You canalso find the process ID by doing:

- `ps aux | grep kubectl`


### Sidecontainers
These are secondary containers that run along with the main application container within the same Pod. They enhace the main app.

## Lab 6.3 Working with Jobs
Create a Job which will run a container which sleeps for three seconds then stops.
```
apiVersion: batch/v1   # Note they belong to batch API!
kind: Job
metadata:
  name: sleepy
spec:
  completions: 5   # How many times the conteiner / Job will run
  parallelism: 2   # How many pods will be deployed at a time
  template:
    spec:
      containers:
      - name: resting
        image: busybox
        command: ["/bin/sleep"]
        args: ["3"]
      restartPolicy: Never
```

---------------------------
## Quiz
Object for scaling and deploying an application:

- Deployment


Objects size in order from tinest to biggest:

1. Container
2. Pod
3. ReplicaSet
4. Deployment


The scaling of applications are based on configuration sdone by the admin.
`Horizontal Pod Autoscaling` **scales resources based on CPU usage.**


CronJobs and Jobd belong to the `batch` API group.

A `DaemonSet` can run just **ONE** Pod on each node.