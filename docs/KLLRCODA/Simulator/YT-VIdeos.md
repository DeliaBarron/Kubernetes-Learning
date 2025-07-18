# EXAM TASKS:
## 1.  Scale a deployment
- `k scale deploy dragon --replica=8`
- `k get deploy`

## 2 ClusterIP, NodePort, Loadbalancer service types
Edit the deployment "dragon" to expose TCP port 80 and name the port http.
Create a Nodeport Service named "dragonsvc" to expose the Pods in the Deployment

> There is no manifest of this Deploymement locally
- go to the internet, get how to get port on a Pod

### logic steps
- create deploy if needed
- expose deployment



- `k edit deploy dragon`
-  Go to the spec of the deployment and the seccion of the containers as it is the part where we declare how to create the containers

- add: 
```
spec:
  containers:
  - image: box
    ports: 
      - name: http
        containerPort: 80
        protocol: TCP

```

now that the deploy opens the port 80 we can expose  it as service

- `k expose deploy dragon --type=NodePort --name=dragonsvc`

check the service and the targetPort
- `k describe svc dragonsvc`

## 3 Manage persistent volumes and persistent volume claims
1. create a PVC named rwopvc that does the following:
2. Capacity of 4Gi
3. acces mode of ReadWriteOnce
4. mount to a pod named rwopod at the mount path /var/www/html

### Logic
create a pvc >> add the capacity, name and mount path.
 Create the pod that will use t /mount it on.

 // vim pvc.yaml

```
apiVersion: v1
kind: PersistentVolumeClaim 
metadata: 
  name: rwopvc
spec:
  accesModes:
    - ReadWriteOnce
  volumeMode: Filesystem
resources: 
  requests:
    storage: 4Gi
```
// vim pvc-pod.yaml
```
apiVersion: v1
kind: Pod
metadata: 
  name: rwopod
spec:
  containers:
    - name: pod-name
      image: nginx
      volumeMounths:
      - volumePath: "/var/www/html
        name: pathname
  volumes:
  - name: vol-name   // name doesnt really matter we can give the name we want
    persistentVolumeClaim:
      claimName: rwopvc
```

create both, First the pvc then the pod

- `k apply -f pvc-pod.yaml `
- `k apply -f pvc.yaml`

### 4 Manage PV and PVC
Create a PV named rompv with the access mode ROM and a capacity of 6 Gi

// PV.yaml
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol
  labels
```