# TASK 1
`kubectl config` commands necessary for change of context and users

K8s kubectl checks for the file $HOME/.kube/config
If we are using another path we can specify it with `--kubeconfig` then the path and then all the subcommands we normally would use

k --kubeconfig /file/path config get-context -o name

How to decode the certificate Base64
`echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1...........RS0tLS0tCg== | base64 -d > base.file`
Question 2 | MinIO Operator, CRD Config, Helm Install
 
# Task 2
Operators



# Task 3
- to see ehat controller is managing this pod you can get all controllers and grep the name base of the pod
`k -n namespace get deploy,ds,sts | grep pod-name`

then u get the controller name and scale it down:
`k -n namespace scale sts sts-name --replicas=1`

Use label selectors too — for example:
`kubectl -n <namespace> get all -l app=nginx`

If a Pod has a label like app=nginx, and so does a Deployment or StatefulSet, it’s a good sign they’re related.

# Task 4


# Taks 5 

# Task 6

# Taks 7
`k top`: the top commands allows you to see the resources of the pods and nodes. This requires the Metrics Server to be installed.

K top gives the Used cpu and memory.

Commands: 
`k top node`
`k top pod --containers`


# Task 8
kubeadm bootstraps and configures k8s cluster.
- Initialize a controlplane: `kubeadm init `
- Join  a node: `kubeadm join` you join the nodes FROM the nodes. 

kubelet:
Runs on everynode.
ensures all containers run as expected.

When joining a node, both kubelet and kubeadmin should match withthe k8s version on the control plane.

If by restarting the service kubeadmin or kubelet at this point doesnt work then u sgho

kubeadm, kubelet and kubectl are installed on the system so if you want to update them u update them in your Linux system NOT in the cluster.
thats why we use apt update on the cp and nodes to update them

VS `kubeadm update` 
**this kubeadm command updates kluster components** such as kube-apiserver, kube-controller-manager, kube-scheduler


## order
- on cp see the k8s version: k get node
- change to node and check for the kukbelet version and kubeadmin and kubectl
- apt update
- apt install kubectl=1.32.1-1.1 kubelet=1.32.1-1.1  # the version of ur cp
- kubelet --version  to see the new version installed
- service restart kubelet   # ALWAYS restart kubelet as it is a daemon on the system

## join node
ON THE CONTROLPLANE:

- kubeadm token create --print-join-command # to get the token and command too for later use
- kubeadm token list

ON NODE:
`kubeadm join 192.168.100.31:6443 --token pwq11h.uevwb20rt81e6whd --discovery-token-ca-cert-hash sha256:cb299d7b2025adf683779793a4a0a2051ac7611da668f188770259b0da68376c `  # the token command printed before

- service status kubelet to ensure kubelt is good and running as kubeadm join doesn start the service automatically.
- kubectl get nodes to prove the node joined




# Taks 9
https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/  

the `kubectl` command is a tool that talks to the `k8sAPI`
the `k8sAPI` is an API server that controls the cluster

kubectl is a client sending request to the API.
-------------

So, by default, all pod gets assigned the default `service account` or the one specified at creation. Service Account should be at the same namespace 

| Resource 1          | Resource 2                |                     Why?                                             |
|---------------------|---------------------------|----------------------------------------------------------------------|
| Pod                 | ServiceAccount            | Pods can only mount/use ServiceAccounts from their own namespace     |
| Pod                 | ConfigMap/Secret          | Pods reference them by name, and names are namespace-scoped          |
| Pod                 | PersistentVolumeClaim     | PVCs are namespaced; must be in same namespace as the Pod            |
| Deployment/Pod      | Service (same namespace)  | Services are namespaced; a Service in the same NS is auto-discovered |
| RoleBinding         | Role                      | RoleBindings bind to Roles in the same namespace                     |
| Pod                 | LimitRange/ResourceQuota  | These policies apply only within the same namespace                  |


- Create a pod yaml with **kubectl run** : `k run api-contact --image=nginx:1-alpine --dry-run=client -o yaml > 9.yaml`

- get the service account: `kubectl get serviceaccounts -n <namespace>`

- under `spec` add the `serviceAccountName`  **## be careful about the args key and the run and namespace value.**

- get inside the pod: `k exec -n ns-name pod-name -it -- sh`


`curl -k https://kubernetes.default/api/v1/secrets`

we will see that the request is made without the token from our serviceaccount.


By default, a Pod is associated with a service account, and a credential (token) for that service account is placed into the filesystem tree of each container in that Pod, at `/var/run/secrets/kubernetes.io/serviceaccount/token`

save the token and tell the pod to use this token for the k8s API to authorize our request:
- `TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)`
- curl again using this token : `curl -k https://kubernetes.default/api/v1/secrets - H "Authorization Bearer ${TOKEN}"`


> Kubernetes adds environment variables into the pods such as the KUBERNETES_SERVICE_HOST and PORT.
> This is the ClusterIP address of the k8s service in the default namespace. when a pod requests https://${KUBERNETES_SERVICE_HOST} (or https://kubernetes.default) `kube-proxy` forwards it to the API server running on the control plane.



# Task 10  RBAC ServiceAccount Role RoleBinding

## RBAC
- `Role`: grant persmissions to a specific serviceA or user, bounded within a namespace
- `ClusterRole`: permissions across the entire cluster. bounded w a user or services account too 
- `RoleBinding`: **within a single namespace** 
- `ClusterRoleBinding`: references a ClusterRole that defines the specific set of permissions that the user, group or service account is granted across the entire cluster.

**Because of this there are 4 different RBAC combinations and 3 valid ones:**

Role + RoleBinding (available in single Namespace, applied in single Namespace)

ClusterRole + ClusterRoleBinding (available cluster-wide, applied cluster-wide)

**ClusterRole + RoleBinding (available cluster-wide, applied in single Namespace)**

Role + ClusterRoleBinding (NOT POSSIBLE: available in single Namespace, applied cluster-wide)

1. Create a Service Account `k -n namespace create sa sa-name`

2. Grant permissions to a role: `k -n name create role role-name --verb=create --resource=secret --resource=configmap`

3. Bind Role to the Service Acc: `k -n name create rolebinding processor --role=role-name --serviceaccount=namespace:sa-name`

4. test the RBAC with: `kubectl auth can-i <verb> <resources> --as <system:serviceaccount:<namespace>:<serviceaccount-name>` 

ServiceAccoun
> read more about these past commands. What else can i do with can-i or role or rolebindig flags for  example!!!

> when u create a Pod. You should always give it a name.


# Task 11 DaemonSet on all Nodes

DaemonSet ensures every nodes (all or established nodes) run a copy of a Pod.

**Deployment** = run N copies of a Pod, anywhere.

**DaemonSet** = run 1 copy of a Pod on each node.

Uses of a daemon: 
- running a cluster storage daemon on every node
- running a logs collection daemon on every node
- running a node monitoring daemon on every node


|Deployment|DaemonSet|
|---|---|
|stragety : how updates to the Deployment’s pods are rolled out ||
|replicas||

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  creationTimestamp: null
  labels:
    id: ds-important
    uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
  name: ds-important
  namespace: delians
spec:
  selector:            # How the ds selects pods it manages. MUST MATCH LABELS ON POD TEMPLATES EXACTLY
    matchLabels:
      id: ds-important
      uuid: 18426a0b-5f59-4e10-923f-c0e078e82462 
  template:
    metadata:
      creationTimestamp: null
      labels:          # Labels assigned to the pods created by the Daemonset. MUST MATCH the MATCHLABELS ABOVE
        id: ds-important
        uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
    spec:              # Pod spec that defines containers, RESOURCES and tolerations....
      containers:
      - image: httpd:2-alpine
        name: httpd
        resources:
          requests:
            cpu: 10m
            memory: 10Mi
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/control-plane
```

once the DaemonSet is applied. You can see where each of the pods are running where: 

- `k get pod -l id=ds-important -o wide`


# Task 12 Deployment on all nodes
- create a deployment 
`k -n <namespace> deployment <name> --image=<> --dry-run=client -oyaml > deploy.yaml`

## Pod affinity
https://medium.com/@prasad.midde3/understanding-node-affinity-pod-affinity-node-selector-and-pod-anti-affinity-in-kubernetes-7899e218ac6d

feature that allows you to influence where the pods are scheduled baes onthe labels of other existing pods


### PodAntiAffinity
When we need to run a Pod on a node where another Pod of a specific label is not already running.

Prevents pods to be schedule on teh same node as the others based on certain label selectors


# Task 13 Gateway Api Ingress
When to use GAteway API?: when your application require header-based routing or more precise control over traffic.

GatewayClass references a Gateway. Also contains the name of the controller that implements the class

The Gateway contains the instance of traffic handling. **Defines a network endpoint**

HTTPRoute represents the configuration that is applied to the underlying Gateway implementation. **It specifies the routing behavior fo the HTTP requests from a Gateway listener to a backend network endpoint**

## HTTPROUTE
- `parentsRefs`: this declares under what gateway we will operate this routing. This Gateway must exist.

- `hostnames`: restricts the rout to apply ONLY if it was made to this hosts.

- `rules`: contains:
    - `matches`: what kind of rout it matches ( /mobile, /desktop).
    - `backendRefs`: where to send this matches. 


# Task 14 Certificates

with OpenSSL
`openssl x509 -noout -text -in apiserver.crt``

compare the same date with kubeadm:
`kubeadm certs check-expiration  | grep apiserver``

`kubedam certs renew apiserver`

# Task 15 | Network Policies

# Taks 16 |  Update CoreDNS Configuration
CoreDNS uses a configMap as a default 
do a backup for safety

if you change a secret or configmap on a deployment you can do rollout restart do the pods get this info: 
`k rollout restart deploy coredns`

# Task 17 
create a pod k run -n delians pod-name --image=image --labels="pod=name,container=name"

get where the pod is running
`k get pod pod-name -o wide`

connect to that node
get info of the containers 

`crictl ps`

`crictl inspect container-ID | grep runntime`

`crictl logs container-ID`
