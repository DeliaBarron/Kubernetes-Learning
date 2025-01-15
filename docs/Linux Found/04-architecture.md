# Kubernetes Architecture
The k8s cluster is driven by API calls to **operators**.

When building a cluster using `kubeadm` the `kubelet` process is managed by systemd.Once running it starts all the pods found under `/etc/kubernetes/manifests`.

## Components of Control Plane

- **kube-apiserver**: all actions are validated and accepted by this agent. It is the only connection to the etcd database. Only kube-apiserver communicates with the etcd database.
- **kube-scheduler**
- **etcd Database**: where persistent information is kept. The first request to update a value travel via the kube-apiserver which then passes along the request to etcd in a series.
- **kube-controller**: control loop daemon which interacts with **kube-api**

## Components of Worker Nodes
**kubelt**  and **kube-proxy** and the **container engine (containerd)** run on the workers.
It accepts ***PodSpec*** (descriptions of pods) and will configure the node until the specification has been met.

Kubelet creates or gives acces to storage, Secrets and ConfigMaps.

- Uses **PodSpec**.
- Mounts volumes to Pod.
- Downloads secrets.
- Passes request to local container engine.
- Reports status of Pods and node to cluster.

-----
> ConfigMaps VS. PodSpec
> ConfigMaps are used to configure *settings for containers* running in a pod *in the same namespace*.
> You can write a pod spec that refers to a ConfigMap and configures the containers in that pod based on its ConfigMap data.

- **kubelet** makes sure that the containers that should run are actually running. it interacts with the container engine.
- **kube-proxy** manages the network conectivity to containers through *IP Tables*.

## Operators / Controllers / watch-loops
A loop process recieves an object, the logic of the operator (Informer) is used to create or modify some object until it matches the specification.

Some eponymous operators:
- endpoints
- namespace
- serviceaccounts

These manage the eponymous resources for Pods.

**Deployments** manage **replicaSets** which manage Pods *running the same podSpec or replicas*.

## Service Operator
Is an operator which listens to the *endpoint* op. **to provide a PERSISTENT IP FOR PODS**.
Then the **service operator** sends messages via the api forwarding settings to the kube-proxy on every node.

Service can:

- Connect Pods together
- Expose Pods to Internet
- Decouple settings
- Define Pod access policy
Connect Pods together

## Pods
Due to shared resources a Pod follows a one-process-per-container architecture.
Containers in a Pod are started in parallel. You can order startup through `InitContainers`.
Containers in the same pod share storage and **the same IP address**.

If there are more than one container in a pod, to communicate with each other they must either use:

- the loopback interface
- shared filesystem

Usually there is a **main container** and **Sidecar containers** that handle auxiliary tasks like logging, monitoring or proxying.



## Containers
K8s actuallt doesnt allow direct container manipullation but we can manage the resources they are allowed to consume.
- In the PodSpec you can pass parameters to the container runtime with `resources:`.
- `ResourceQuota` allows also to set soft and hard limits in a namespace. This quota icludes a `scopeSelector` which runs a pod at a specific priority using the `priorityClassName` specification.


### Init Containers
They must complete BEFORE app containers will be started. If they fail it will be restarted until it is completed, WITHOUT the app container running.

## API Call Flow
Kubectl makes a request or post information to kube-apiserver, kube-api sends the information to the etcd database. Kube-controller-manager request of information if the spec has changed. so if the kube-api doesnt has the changes and answers this to the kube-controller-manager which will them request the api to create the new deployment. Once is created then will be saved to the etcd database. *If the **spec** has changed, then a new deployment should be done.*

Here the **deployment operator** request for a replicaset, then the replicaset is running and asks for existence of pods that match the replicaset. The back and forth continues between operators and pods, then the `kube-api` (once with the pod information) asks the scheduler, which worker should get the pod spec.
The `kube-api` sends the information to the particular `kubelet` plus `kube-proxy` info.  This `kube-proxy` network information is sent to all the kube-proxies (even to the ones on the local machine so they are all aware of what is happening).

At this point `kubelet` on each worker is responsible for downloading all the configMaps, secrets and mounting points of filesystems.
Once the container has been created by the engine, the engine send the information back to `kubelet` and `kubelet` back to `apiserver`.

## Node
- Is an API object created outside the cluster representing an instance.
- While a **control plane** must be Linux, worker nodes can also be Microsoft.
- If the kube-apiserver cannot communicate with the kubelet on a node for 5 min, `NodeLease` will schedule the node for deletion.

### To delete a node from the **cluster**

- `kubectl delete node <node-name>` : removes the node from the API Server (pods will be evacuated)
- `kubeadmn reset` : this will remove cluster-specific information.
- If you are not reusing the node, you can also remove the iptables information.

> To view CPU, memory, and other resource usage, requests and limits use the kubectl describe node command. The output will show capacity and pods allowed, as well as details on current pods and resource utilization.

## Pod

![](/docs/img/pod.png)
When we have multiple containers in a pod, the ***pause container*** is used to get an IP address, then all the containers in the pod will use its network namespace. (same hostname).

> Pause container: used by the cluster to reserve the IP address in the namespace prior to starting the other pods.

- IP addresses are assignes to the pod before the containers are started and then will be inserted into the containers.

- The kube-controller-manager handles the watch loops to monitor the need for endpoints and services, as well as any updates or deletions.

## Services
We use services to connect **Pods** to another or to **outside the cluster**.

CLuster IP are build in front of a Pod. One or more pods that match a label selector can forward traffic to the IP address.

## Pod-to-Pod Communication
You can use CNI configuration Files to configure the network of **a Pod** and provide **a single IP per Pod** but can NOT use CNI for pod-to-pod communication across nodes.

The requirement from Kubernetes is the following:

- All pods can communicate with each other across nodes
- All nodes can communicate with all pods
- No Network Address Translation (NAT)


### LAB NOTES
#### 4.1 Basic Node Maintenance
> we will backup the etcd database then update the version of Kubernetes used on control plane nodes andworker nodes.

In order to use TLS, find the three files that need to be passed using the `etcd`

- `cd /etc/kubernetes/pki/etcd/`   ## pki= public key infrastructure
- `echo *`       ## echo cause etcd image doesnt contain find or ls commands
- to see the certificates.
- `etcdctl -h`


The snapshots of the etcd cluster must go to the etcd containers at `/etc/kubernetes/manifests/etcd.yaml`  `data-directory`

In order to access the etcd api you need always the certificates being passed to the commands.
- To check the etcd db health:

`kubectl -n kube-system exec etcd-controlplane1.staging.pro54.srservers.net  -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint health`

- To dislay it in a table form AND | OR for the whole cluster:
`kubectl -n kube-system exec etcd-controlplane1.staging.pro54.srservers.net  -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint health`

Create a snapshot:

- `kubectl -n kube-system exec etcd-controlplane1.staging.pro54.srservers.net  -it -- etcdctl  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key --endpoints=https://127.0.0.1:2379 snapshot save /var/lib/etcd/snapshot.db`

Save a backup of:

- snapshot: The snapshot of etcd database stores the entire Kubernets cluster state.
- kubeadm-config.yaml: file used to initialize the cluster, crutial for rebuilding the control plane and has cluster settings.
- PKI(public key infrastructure): keys for secure communication.





#### Upgrading the Cluster
CONTROL PLANE:
- updating package metadata for API:

 `sudo apt update`

- View the available packages:
 `apt-cache madison kubeadm`

- Remove the hold on kubeadm and update the package.
- Remember to update to the next major release's update!!
**It can be used to place a package on hold (so it won't be automatically upgraded) or unhold it (so it can be upgraded)**:

 `apt-mark unhold kubeadm`
- `apt-get install -y kubeadm=<last-version-from-madison>`

- hold the package again to prevent updates along with other software as if kubeadm is automatically upgraded during routine system update, but kubelet and kubectl arent, it could result in version mismatches that might destibilize the cluster.

`apt-mark hold kubeadm`: put to hold again .

- Check the new version

`kubeadm version`

- `kubeadm upgrade plan`

- `kubeadm upgrade apply v1.30.4`

- `kubectl drain cp --ignore-daemonsets`
- To check the node you drained is now Disabled for Scheduling.

`kubectl get node`

- `apt-mark unhold kubelet kubectl`

- `apt-get install -y kubelet=1.31.1-1.1 kubectl=1.31.1-1.1`

- `apt-mark hold kubelet kubectl`

- `systemctl daemon-reload && systemctl restart kubelet`

- `kubectl uncordon <cp>`

- Now the cp must be back to Ready Status:
`kubectl get node`

*kubeadm upgrade in all controlplane one by one,*
*then you drain worker nodes and upgrade kubeproxy, kubectl and kubelet one by one*

WORKER NODES:

#### 4.2 Working with CPU and Memory Constrains
- `kubectl create deployment <name> --image vish/stress`

- `kubectl get deployment`

- `kubectl describe deployment <name>`

- edit the yaml deployment
- replace with the new edited file:

    `kubectl replace -f <filename.yaml>`

    get the logs of the container to see the changes being applied in the right way

    `kubectl get po`

    `kubectl logs <po-name>`

**There are immutable fields that will require you to delete and recreate the deployment such as:**

-  spec.selector: The selector for Pods; if you change this, you need to create a new Deployment.

- spec.template.metadata.labels: If the labels defined in the Pod template change, you need to delete and recreate the Deployment..

- spec.strategy.type: Changing the deployment strategy type (e.g., from RollingUpdate to Recreate).


#### Quiz
- a pod canonly have assigned to it 1 IP
- main agent on a WORKER node is: `kubelet`
- `Service` object connects resources together and handles **Ingress** and **Egress** traffic.
- `kube-apiserver`: main configuratio  agent on a MASTER server.


