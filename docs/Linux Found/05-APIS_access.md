# API Access
KubernetesThe resources endpoints are to be found at the API's. Is the main agent for communication between cluster agents from outside the cluster is the kube-apiserver.

## RESTful
kubectl makes API calls on your behalf, responding to typical HTTP verbs.

## Checking Access
The following shows what user bob could do in the default namespace and the developer namespace, using the auth can-i subcommand to query (commands and outputs):

```
$ kubectl auth can-i create deployments
yes

$ kubectl auth can-i create deployments --as bob
no

$ kubectl auth can-i create deployments --as bob --namespace developer
yes
```
## K8s API Terminology
- A *resource type* is the name used in the URL (pods, namespaces, services)
- A list of instances of a resource type is known as a **collection**


## Optimistic Concurrency
The K8s API allows clients to make an initial request for an object or a collection and then to track changes since that initial request: a **watch**. Clients can send a **list** or a **get** and then make a follow-up **watch** request.

## Using Annotations
Labels are used to work with objects or collections of objects; annotations are not.

```
$ kubectl annotate pods --all description='Production Pods' -n prod

$ kubectl annotate --overwrite pod webpod description="Old Production Pods" -n prod

$ kubectl -n prod annotate pod webpod description-
```

## Simple Pod
- **kind**: the type of object to create
- **metadata**: at least a *name*
- **spec**: what to create and parameters

```
apiVersion: v1
kind: Pod
metadata:
    name: firstpod
spec:
    containers:
    - image: nginx
      name: stan
```

- `kubectl create -f simple.yaml`
- `kubectl get pods`
- `kubectl get pod firstpod -o yaml`
- `kubectl get pod firstpod -o json`

## Verbosity
**kubectl** has a verbode mode argument which shows details from where the command gets and updates information.
The level of verbosity goes from 0-10.

- ` kubectl --v=10 get pods firstpod`

## Access from the outside
The state of the reources can be changed using standard HTTP verbs like: GET, POST, PATCH, DELETE.
**kubectl** calls **curl** on your behalf and you can use it from outside the cluster to view or make changes.

## Namespaces
These are kernel features that allows the creation of isolated environments, where processes can have their own view of global resources.
> its like creating "mini" operating systems within a simple physical system.

There are 4 namespaces when a cluster is firs created:

### 1. Default

Where all the sources are assumed, unless set otherwise.

### 2. kube-node-lease

Contains Lease Objects that are used to track **node heartbeats** which are essentially "pings" from the nodes to the control plane to signal that they are still healthy  and operational.
Every **node** in the cluster as a Lease object in the **kube-node-lease**.


#### Lease Object Structure

- **HolderIdentity**: The node that holds the lease (the node itself).
- **LeaseDurationSeconds**: for which the lease is valid.
- **AcquireTime & RenewTime**
- **LeaseTransitions**: Counts how many times the lease has changed hands.

#### Process

- Each node ipdates its corresponding Lese object by renewing the lease. (sending a "heartbeat to the control plane")
- The kubelet (the agent running on each node) periodically updates the Lease with a renewal time.
- The k8s **control manager** checks that:
    - the lease gets renewed, otherwise, assumes the node is down or unhealthy.
    - If a node’s Lease expires, Kubernetes will take action, such as marking the node as NotReady and eventually evicting the node's Pods to be rescheduled on other nodes.

### kube-public
General information is included. No need for authentication to read this namespace.

## Working with Namespaces
- `kubectl [command] [type] [Name] [flag]`


### Table: List of API Resources

- all
- events (ev)
- podsecuritypolicies (psp)
- certificatesigningrequests (csr)
- horizontalpodautoscalers (hpa)
- podtemplates
- clusterrolebindings
- ingresses (ing)
- replicasets (rs)
- clusterroles
- jobs
- replicationcontrollers (rc)
- clusters (valid only for federation apiservers)
- limitranges (limits)
- resourcequotas (quota)
- componentstatuses (cs)
- namespaces (ns)
- rolebindings
- configmaps (cm)
- networkpolicies (netpol)
- roles
- controllerrevisions
- nodes (no)
- secrets
- cronjobs
- persistentvolumeclaims (pvc)
- serviceaccounts (sa)
- customresourcedefinition (crd)
- persistentvolumes (pv)
- services (svc)
- daemonsets (ds)
- poddisruptionbudgets (pdb)
- statefulsets
- deployments (deploy)
- podpreset
- storageclasses
- endpoints (ep)
- pods (po)

```
$ kubectl get ns

$ kubectl create ns linuxcon

$ kubectl describe ns linuxcon

$ kubectl get ns/linuxcon -o yaml

$ kubectl delete ns/linuxcon
```

Once a namespace has been created, you can reference it via YAML when creating a resource.
```
$ cat redis.yaml

apiVersion: V1
kind: Pod
metadata:
    name: redis
    namespace: linuxcon
```

## Additional Resource Methods
This:

```
$ curl --cert /tmp/client.pem --key /tmp/client-key.pem \
--cacert /tmp/ca.pem -v -XGET \
 ht‌tps://10.128.0.3:6443/api/v1/namespaces/default/pods/firstpod/log
 ```

 would be the same as the following:

 - `kubectl logs firstpod`