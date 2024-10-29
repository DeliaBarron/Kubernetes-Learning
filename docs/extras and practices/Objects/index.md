# K8s Objects
## Kubectl
`kubectl` uses the K8s API to interact with the cluster.
When you create a Deployment you will need to specify the container image for the app and the number of replicas that you want to run.

## Overview of a Deployment
1. Define Nodes (set up cluster)
2. Create `kind:deployment` YAML file.
3. Apply YAML file with `kubectl apply` to create PODS running your container.
4. Expose the deployment as a service to make it accessible. Creating a services exposes your PODS outside the cluster.

## Kubernetes Object Model
In k8s context, "resources" refers to objects of any kind that can be managed by k8s API.

With each Object we declare the desire state in the `spec` section.

In K8s we define the object type with `kind`. Some examples of this objects are:
- Nodes
- Namespaces
- Pods
- ReplicaSets
- Deployments
- DaemonSets

*Example of a deployment object for k8s:*
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```


<span style="color:mediumslateblue;">Here, the data section below the **spec** field has to be submitted to the Kubernetes API Server as the API request to create the object must have this information describing the desired state.n
This definition manifest are provided in a YAML format which gets converted by Kubectl in a JSON Payload and sent to the API Server.
</span>


## Labels
They are used to organize and select a subset of objects, based on requirements in place.
**Controllers use labels to logically group decoupled objects rather that using objects**
Labels are used to specify attributes of objects that are meaningful and relrevant to users.


### Controllers / Operators
The contoll the Pods replications, healing, etc..
Controllers are loop functions that are constantly comparing the current state o the cluster with the desired state. If there is discrepancy it will take action and bring the cluster back to the desired state.

*Operators link resources to one or more custom resources**

> Controllers use *labels* to logically group objects.

Some **Controllers** are:
- **Deployment**: Manages rolling updates and rollbacks for *Pods* and *ReplicaSets*.
- **ReplicaSets**: Ensure specified number of Pod replicas are given and running at any time.
- **DaemonSets**: Ensures a copy of a Pod is running.
- **Job Controller**: running-off tasks ensuring that a specified number of Pods successfully terminate.

#### ReplicationSet
We ca run in parallel, multiple instances of the applicatio. The lifecycle of the app **defined by a Pod**
 will be overseen by a controller - the **ReplicaSet**.

#### Deployments
The recommended controller for orchestation of Pods as it also allows management of updates of Pods.
A **Deployment** creates automatically a **ReplicaSet** which then creates a Pod.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-deployment
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - name: nginx
        image: nginx:1.20.2
        ports:
        - containerPort: 80

```
<span style="color:mediumslateblue;">
In `spec` we define the desire state of the Deployments object with 3 replicas (3 pods instances).
The pods will be created using information at the `spec.template` so in this case as the **Pod** object is nested, it loses its own apiVersion and kind (both being replaced by template).
In `spec.tempate.spec` then, we start the actual definition of the **Pod** which creates a single container using the `nginx:1.20.2` image.
</span>

### Rollout Strategy
Rollout is the process of deploying a new version of an application or services. There are 2 common rollout strategies. Rolling Update and recreate.

**When using Deployments a Rollout is only triggered by updating the Deployment's Pod template**

#### Rolling upgrade
Gradually replaces pods runniing the old version with the old version with new ones.

#### Rolling recreate
Deletes all the pods and creates new ones. Rollback is the process of undoing a rollout and reverting to a previous version of the application.

> Rolling Updates are also for controllers, deamonsets and statefullsets.


#### Commands
- Update the container image of a deployment.
`kubectl set image deployment/<deployment_name> <container_name>=<new_image>`

- Retrieve the status of a deployment rollout
`kubectl rollout status deployment/<deployment_name>`

List revision history of a deployment
`kubectl rollout history deployment/<deployment_name>`

Rollback a deployment to a previous revision
`kubectl rollout undo deployment/<deployment_name>`