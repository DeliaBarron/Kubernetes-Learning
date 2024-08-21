# 02 Basics of Kubernetes

## Kubernetes Architecture
*See picture in course*

Kubernetes is made of **control planes**, that run a API server, scheduler. controllers and storage system (etcd) that keeps the state of the cluster, configurations and networking config.

- The **kube-scheduler** gets forwarded the  pod `spec` and finds a suitable **node** to run those containers.
- Each **node** in the cluster runs **kube-proxy** and **kubelet**.
- **kubelet** will recieve the request to run the container, manage the resources and works with the container engine which could be Docker, containerd, cri-o or more.

- **kube-proxy** manages networking rules, exposing the container to others in the same network or in the outside world.

## Terminology
### Containers
Containers are part of a larger Object called <span style="color:mediumslateblue">Pods</span>.
Containers inside a Pod share the same:
- Ip address
- access to storage
- namespace

### Namespaces
Namespaces (shortly) are a method by which a single cluster used by an organization can be divided and categorized into multiple sub-clusters and managed individually.


### Orchestration
**Orchestration** is done through *watch-loops* called controllers or operators that call for an object state to the API and matches the desired state with the current one.

For controlling containers, the **Deployment** operator is used. It applies a ***ReplicaSet*** that will create or terminate Pods until the status matches the `podSpec`.



