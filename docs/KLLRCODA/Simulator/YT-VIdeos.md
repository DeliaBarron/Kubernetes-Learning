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

## 4 Manage PV and PVC
Create a PV named rompv with the access mode ROM and a capacity of 6 Gi

// PV.yaml
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: rompv
spec:
  capacity:
  storage: 6Gi
  accessModes: ReadOnlyMany
```
- `kubectl apply -f pv.yaml`

## 5 How to use Ingress controllers and Ingress resources
1. Create an Ingress resource named luau that routes traffic on the path /aloha to the aloha service on port 54321.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: luau
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /aloha
        pathType: Prefix
        backend:
          service:
            name: aloha
            port:
              number: 54321
```
- `kubectl apply -f `
## 6 Monitor cluster application resource usage
1. identify all pods in the integration namespace with the label app=intensive
2. Determine which of these Pods is using the most CPU resources.
3. Write the name of the Pod consuming the most resources to /opt/cka/answers

- `k top pods -n integration -L app=intensive`: returns memory/cpu consumption of pods.
- L returns a column showing the values (if any) of that label

## 7 Configure Pod admission and scheduling
1. Create a Pod named noded that uses the nginx image.
2. Ensure the Pod is scheduled to a node labeled disk=nvme.

- `k get nodes -L disk` to get node

```
apiVersion: v1
kind: Pod
metadata:
  name: noded
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    disk: nvme
```

`kubectl apply -f pod.yaml`
ensure: k get pod noded -o wide

## 8 Understand the primitives used to create robust, self-healing, app deployments.
1. Create a Pod named multicontainer that has two containers:
  - Container running the redis:6.2.6 image
  - Container running the nginx:1.21.6 image

```
apiVersion: v1
kind: Pod
metadata:
  name: multicontainer
spec:
  containers:
  - name: redis
    image: redis:6.2.1
  - name: nginx
    image: nginx:1.21.6
```
`kubectl apply -f pod.yaml`
k get pod multicontainer : this should show 2/2

## 9 Sidecar container for logs
1. Add a sidecar container using the busybox image to the existing Pod logger.
2. The container should be mounted at the path /var/log and run the command /bin/sh  -c tail -f /var/logs/log1.log


> Both containers must mount the same volume in the same path. This volume must be declared in `spec.volumes`

```
apiVersion: v1
kind: Pod
metadata:
  name: logger
spec:
  containers:
  - name: app-pod
    image: busybox
  - name: logger
    image: busybox
    args: [/bin/sh, -c, 'tail -f /var/logs/log1.log']
    volumeMounts:
    - name: logz
      mountPath: /var/log
  volumes:
  - name: logz
    emptyDir: {}
  nodeName: node-1  
```

## 10 Manage role based access control (RBAC)
1. Create a ClusterRole named app-creator that allows create permissions for DaemonSets, statefullsets, deployments
2. Create a ServiceAccount named app-dev
3. Bind the ServiceAccount app-dev to the ClusterRole app-creator using a ClusterRoleBinding

- `k create clusterrole app-creator --verb=create --resources=daemonsets --api-groups=apps`

- `k create serviceaccount app-dev`
- `k create clusterrolebinding name --clusterrole=name --serviceaccount=namespace:name`

## 11 TRoubleshoot clusters and nodes
1. Inspect the nodes controller and node-1 for any taints they have. Write the results to their respective files:
2. controller /opt/control.taint
3 node 1.  /opt/node.taint


Taint info are in `kube describe node controller | grep -i taints`

## 12 Use ConfigMaps and Secrets to configure applications
1. Create a ConfigMap called metal-cm containing the file /mycode/yaml 
2. To the deployment "enter-sandman" add the metal-cm mounted to the path /www/data/
3. Create the deployment in the metallica Namespace

- `k create confimap metal-cm --from-file=/mycode/yaml -n metallica`

ConfigMap and deployment should be in the same NAMESPACE!!!!!


```
apiVersion: v1
kind: Deployment
metadata:
  name: enter-sandman
  labels:
    app: nginx
spec:
  replicas: 3
  selector: 
    matchLabels:
     app: conf-pods-selector
  template:
    metadata: 
      labels:
        app: conf-pods-selector
    spec:
      containers:
      - name: mypod
        image: redis
        port:
        - containerPort: 80
      volumeMounts:
        - name: configMap
          mountPath: "/www/data"
          readOnly: true
  volumes:
  - name: cofigMap
    configMap:
      name: metal-cm
```

`k apply -f -n metalica deploy.yaml` 
if they stay in ContainerCreating

## 13 ConfigMaps and Secrets to configure applications
1. You will adjust an existing pod named kiwi-secret in namespace kiwi.
2. Make a new secret named juicysecret. it must contain the following key/values pairs: 
  username=kiwis, password=deli
3. make this content available in the pod kiwi-secret-pod as the following environment variables: USERKIWI and PASSKIWI

> Secrets (like ConfigMaps) Should be in the same namespace as the objects!!!!!!!!!!!!1


```
apiVersion: v1
kind: Pod
metadata:
  name: kiwi-secret
  namespace: kiwi
spec:
  containers:
  - name: kiwi-secret
    image: nginx
```

k create secret juicysecret --from-literal=username=kiwis --from-literal=password=deli

OR 
```
apiVersion: v1
kind: Secret
metadata: 
  name: juicysecret
  namespace: kiwi
type: kubernetes.io/basic-auth
stringData:
  username: kiwis
  password: deli

```

mount to pod:

```
apiVersion: v1
kind: Pod
metadata:
  name: kiwi-secret
  namespace: kiwi
spec:
  containers:
  - name: kiwi-secret
    image: nginx
    env:
      - name: USERKIWI
        valueFrom: 
          secretKeyRef:  // if configmap --> configMapKeyRef
            name: juicysecret
            key: username
      - name: PASSKIWI
        valueFrom:
          secretKeyRef:
            name: juicysecret
            key: password
```

- `k apply -n kiwi -f pod.yaml`
- `k exec -it kiwi-pod -n kiwi --  bash`
    echo $USERKIWI

## 14 Define and enforce Network Policies
1. in namespace cherry you'll find two deployments named pit and stem. Both deployments are exposed via a service.
2. Make a NetworkPolicy named cherry-control that: 
3. that prevents outgoing traffic from deployment pit...
... EXCEPT to that of deployment stem
