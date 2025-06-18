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
PV is a storage abstraction
PVC are defined by the pods. the pvc define a volume type using size and type of storage known as **StorageClass**  The cluster attatches the persistentVolume accordingly.
 > *read down* storageClass is dynamic provisioned and automatic.

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


**Shared Volume Example**
```
...
containers
- name: aphacont
  image: box
  volumeMounts:
  - mountPath: /alphadir
    name: sharevol
- name: betacont
  image:box
  volumeMounts:
  - mountPath: /betadir
  name: sharevol
volumes:
- name: sharevol
  emptyDir: {}
   
```
Now if you check this commands:
$ `kubectl exec -ti exampleA -c betacont -- touch /betadir/foobar`
$ `kubectl exec -ti exampleA -c alphacont -- ls -l alphadir` 

**the beta container is WRITING to this emptyDir and alpha ha accces to that and there is nothing to keep th containers from.**


### Persistent Storage Phases
- Provision
How the actual storage is created.
  **static provision:** when the admin of the cluster goes ahead and creates PVs
  **dynamic provision:** kubernetes automatically creates the resource using a `storageClass` when a PVC is made.

- Binding: When a **control loop** on the cp notices the PVC. this PVC must contain a particular amount in size, qccess request and optionaly a storageClass. 
**the watcher locates a matching PV or waits for the storageClass provisioner to create the PV** The PV must at least match the storage amount requested. 
No other PVC can claim the same PV
> If the provision was dynamic, the binding occurs right after the creation.

- Use: The volume is in use when is mounted on the pod container(s) established path.
The volume is unavailable to other pods unless it´s shared (`ReadWriteMany`)

- Release: when the pod is done using it and the API sends request deleting the PVC. The resident data remains depending on the `persistentVolumeReclaimPolicy`.

- Reclaim: has 3 phases:
  1. Retain which keeps the data intact for the admin to handle the storage and data
  2. Delete: tells the storage to delete the API object and the storage behind it
  3. Recycle: removes the mountpoint and makes it available to a new claim

  
  Persistent volumes are not namespaces objects BUT PVC are!

  