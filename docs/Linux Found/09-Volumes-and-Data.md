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

  > Another example
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
spec
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 8GI
```

in the Pod
```
spec: 
  container:
....
  volumes:
  - name: test-volume
  persistentVolumeClaim:
    claimName: myclaim
```

## Dinamic Provision
dynamic provision allows the cluster to request storage from the exterior
the **storageClass** API allows an admin to define PV provisioner of a certain type, passing storage specific parameters.

SO you declare a claim with parameters like the size and you already have a provisioner (aws, ceph,...).

1. Create a PVC  " 10GI, RWO, storageClass:fast"
2. The PVC looks at the `storageClass`  which tells K8s how to create the volume.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-storage
provisioner: kubernetes.io/aws-ebs  # or other backend (GCE, NFS, etc.)
parameters:
  type: gp2 
```
the provisioner plugin handles talking to the storage backend.

3. K8s creates automatically the PV
k8s talks to the storage backend, creates the PV dynamically, the PV gets bound to the PVC

## Secrets
Secrets are another k8s API resource.
They can be manually encoded or via : `kubectl create secret`

Secrets are created and encrypted upon write so you need to recreate every secret.
Multiple keys for encryption are are possible. When Decryotion, every key will be tried. when the secret is decoded, the result will be stored in a file saved as a string.  This file can be used as ENV Variable.

Secrets are stored in the `tmpfs` of the host node.

**ALL VOLUMES REQUESTED BY A POD MUST BE MOUNTED BEFORE THE CONTAINERS WITHING THE POD GET STARTED, SO IN ORDER TO USE A SECRET AS A VARIABLE IN A POD, THE SECRET MUST ALREADY EXIST TOO**



### Mounting Secrets as Volumes
> You can access the values of each key-value pair of a secret as if they were files inside the pod.

lets create a secret:
`kubectl create secret generic my-secret \
         --from-literal=username=admin \
         --from-literal=password=s3cr3t`

this secret would have 2 value keys: username and password.

**When u mount a Secret into a pod as a Volume, each key of the secret file becomes one file of its own and the content of this files are the value that this key has in the secret file**

```
apiVersion: v1
kind: Pod
  metadata:
    name: secret-test-pod
  specs:
    containers:
    - name: app1
      image: box
      command: ["sleep", "3000"]
      volumeMounts:
      - name: secret-mount-vol
        mountPath: /etc/secret-data
      volumes:
      - name: secret-mount-vol
        secret:
          secretName: my-secret
```

And now, inside the container:
`ls -la /etc/secret-data`

You will see: 
- username
- password
 and if you cat them u can see the values as the output.

 `kubectl exec -ti box -- cat /etc/secret-data/password`

 ## ConfigMap
> data on them cannot exceed 1MiB!

 Following the decoupling concept of kubernetes, `configMap` decouples a container image from configuration artifacts.

 They store data as key-value pairs or any format.

 Data on a configMap can come from this files or directly from a literal value.

 **ConfigMaps can be consumed in various ways:**
 - Pods can use them as ENV variables
 - Pod commands can access the values on this files. // pod and the configmap have to be in the same namespce
 - You can use them to populate volumes. as well as setting the acces modes in a volume
 - Can be used by the nodes and the controller


### Env Variables
To  use them as, the pod manifest will use the `valueFrom` key and the `configMapKeyRef`

```
env: 
- name: SPECIAL_LEVEL_KEY
  valueFrom:
    configMapKeyRef:
      name: special-config      // This is how we named the configMap file on the cluster.
      key: special.how          // This is a key inside the configMap
```

so this means that k8s  will look for a ConfigMap like this:

- `kubectl get configmap special-config`





## Lab1

Theres 3 wasy to a config can put data: files, directory and from a literal value.
if you have a file named `favourite` with the value `blue` >>
 then u put this file as a key-value on a configMap : `k create configmap color --from-file=./favourite` 
 `k get configmap color -o yaml`

 then, this is how you can create a pod with ONE env variable inside coming from this configfile.

```
// Pod yaml

apiVersion: v1
kind : Pod
metadata:
  name: shell-demo
spec:
  containers:
  - name: nginx
    image: nginx
    env:
    - name: ilike         // name of the variable the will pod will use to call this value
      valueFrom:
        configMapKeyRef:
          name: color
          key: favourite  // key on the configfile
```

To see the $ilike variable. `k exec shell-demo -- /bin/bash -c 'echo $ilike'`

### env vs envFrom
`envFrom` 
Instructs to crate a veriable from all the sources on the configMap `configMapRef` refers the `config` file name and selects all key-value pairs.

`env`
To select individual key in a configMap. `configMapKeyRef` and then the name of the `config` and the name of the `key` you want to use in the pod.

To see all variables. `k exec shell-demo -- /bin/bash -c 'env'`


### from a YAML
- `kubectl create -f configMap-name.yaml`

### as volume
`volumeMounts` is at the level of `containers.image`  and `volumes` is at the level of `containers`

## LAB2:
- we crated a directory at local (making it the nfs-server)
- export it
- then using a worker node, we installed nfs-common there, and mounted this nfs- server directoy
- Created a pv on the cluster (from local) using a yaml where we say what path, what type of pv and where it is


### Lab 3.
Creat a pvc to use this pv


## Lab 4. Using resource quota to limit PVC count and usage
### Resource Quotas

**Helps admin control how many resources like CPU, memory, storage and pods a particular namespace can use.**

