# Volumes And Data
Directories accessible to containers used to share data.

- emptyDir: temporary storage. Lives as long as the pods does.
- hostPath: it mounts a file/ directory from the host node to the pod. 
- PVC(persistent volume claim): **CONNECTS TO** a persistent volume. for long term storage.
- configMap /secret: For injecting configs or secrets as volumes
- nfs, awsEBS: xternal cloud/network storage.

## CSI
Standard API that defines how the storage systems like Ceph, awsEBS and more can connect to the conteiners orchestrators. So **kubernetes can support storage systems without having to change any source code**.

CSI allows having this drivers deployed as containers into k8s. Out-of-tree replaces in-tree plugins.

-------------

## PV and PVC
Real apps like databases use PVC.
The workflow is :
-  PV --> where the storage is defined, whether is nfs, awsEBS, disk. 
- PVC --> the pod  request the use of this defined PV.
- Pod uses the PVC connecting it through a `volumeMounts`

If you need the data to outlive the pods like for logs to be collected when pod dies, DB to live even if the pods crashes or to have Pods to share data between each other **You will need PERSISTENT STORAGE**

### Persistent Volumes
Storage that has been provissioned. Could be:

- nfs
- cloud disk
- local SSD
and is defined at a cluster level. So that means is another resource on the cluster just as a pod is a resource in the cluster.

If a user deletes a PVC used by a Pod, the pvc will be postponed until is not more in use.
If an admin deletes a PV that is bound to the PVC, this will also be postponed until the pv is not longer bond to the pvc.

You can see the PVC is protected running:
`kubectl descrive pvc` # to get all pvc describe
`kubectl descrive pvc <name>` # to get info from one specific pvc

then at the status, should be terminating and the list of *finalizers* you can see: `kubernetes.io/pvc-protection`

### Persistent Volume Claim
you define how much dtorage u want
- Admin privissions a PV --> pod crates a PVC --> k8s binds the pvc to a matching pv --> Pod **mounts** pvc like a volume.

### Secretes and configMaps 
They can be mounted as volumes. 
These methods are all about how data gets into the container

Flow:
Create the `configMap` where we declare the kind, name  --> Create a Persistent Volume Claim where we declare the pvc name, the access mode and how much storage we want to use -->  Deployment of a pod file where we declare the `volumeMount` with a name, mount path(s), and the `volumes` we are claiming (pvc name) --> to deploy all this we have to apply the 3 files :
- k apply -f configmap.yaml
- k apply -f pvc.yaml
- k apply -f pod.yaml


## Volumes In Pods
Pod specification can declare one or more volumes. 
Each requires a name, a type and a mount point.
The same volume can be available to multiple containers within a Pod. making this a way of communication between containers.
The pod mounts the volume in the containers filesystem. **you can mount it on different paths in each container in the same pod or across pods if the volume type supports it**

### Access Modes
- ReadWriteOnce: allows read-write by single node
- ReadOnlyMany: allows read-only by multiple nodes
- ReadWriteMany: allows read-write by many nodes

For each request by a Node, a `StorageClass` must be declare, otherwise the access mode and the size are the only parameters and there is no configuration to pass this parameters to.

```
# this is how a volumes specs looks in a pod
apiVersion: v1
kind: Pod
metadata:
    name:fordpinto
    namespace: default
spec: 
    containers:
    - image: simple-app 
      name: gastank
      command:
      - sleep
      - "3600"
    volumeMounts:
    - mountPath : /scratch
      name: scratch-volume
    volumes:
    - name: scatch-volume
     emptiDir: {}


```