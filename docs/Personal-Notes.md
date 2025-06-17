# k8s
## Basic Main Concepts
### Pods 
Run one or multiple app containers.
They have their own private/local IP assigned but as they are efemeral or as they can die easily, another concept comes in  handy to avoid application crashes.
When a pod dies, another one will be created but with a different IP this time So to avoid problems we use `Services`.

*pods communicate w each other using a service*

 
### Service
Is an static/permanent IP address that can be attached to each Pod. So even if a Pod dies the service and its IP address will stay.

### Ingress
Requests made to the services first go to Ingress and then, Ingress forwards the request to the service.


### ConfigMap
Usually WITHOUT k8s you would have the URL of an endpoint application (database) in the built application so if that endpoint changes, you would have to rebuild the application, push the new image to the repo, and then pull it on the pod to restart the app.

WITH K8S, you can use `ConfigMaps` that contains the external configurations of the applications. 
This file would contains URL that the application would use. You can connect this to the pod so you dont need to rebuild an image.

If you change secret credentials that also can change in time you can use the component `Secret`.

### Secrets
This are similar to ConfigMaps but they store secret data or credentials.
Is encoded in base 64 format.
Secrets get connected to the pod to be used as env variables or properties files.
 
## Data Storage
If theres a DB container in a pod and the pod restarts or crashes, the date would be gone, so k8s uses `Volumes`.

### Volumes
it attaches a phisicall storage to a pod that can be either:
- Local (same running server node/local machine) where the pod runs.
- remote: cloud storage outside the k8s cluster.

> K8s doesn't manage data persistence. U as an user have to make sure its replicated and securely stored.

## Deployment and Statements
K8s allows to replicate everything.
We have several nodes with the same application which is connected to the SAME SERVICE with:
- same IP
- Loadbalancing

### Deployments
we specify hoe many replicas we need of a Pod.

We CANT replicate DB with Deployments because the DB have a state.
We use `StatefulSet` 

###  StatefulSets
Each Pod gets unique name and network identity and persistent storage.

- k8s manages persisten volumes ensuring that the storage is associated with specific Pod.
- Creation of pods in sequential order.
- 