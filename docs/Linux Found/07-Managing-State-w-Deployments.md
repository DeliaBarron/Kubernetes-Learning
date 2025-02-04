# Deployments
When added to the cluster, the **controller** will create automatically a `ReplicaSet`and a Pod automatically. The **containers**, their **settings** and applications can be modified via an update, which generates a new **ReplicaSet** which generates new Pods with the new configurations.


> Most updates can be staged to replace previous objects as a rolling update.

## Deployment Details & Commands
- `kubectl create deploymemt dev-web --image=nginx:1.21`

After creating this resource or object you can get them in YAML or JSON:

- `kubectl get deployment -o yaml`
- `kubectl get pods -o yaml`

## Deployment Configuration Metadata
Here we would find **labes, annotations and other non-configutation** information.

**1. Annotations:** Further information for administrative tracking or third-party.
They cannot be used to select an object with kubetl **unlike labels**.

**2. Generation**: Times this file has been edited.

**3. Labels**: Strings to exclude or select objects for use with `kubectl`.

**4. Name:** Required string passed from cli. It must be ***unique to the namespace***.

5. **UID**: Remains a unique ID for the life of the object.

## Deployment Configuration Spec
There are **two** spec declarations. The first one will modify the **ReplicaSet** created while the second will pass along the **Pod** configuration.

1. **progressDeadlineSeconds**: Time in seconds until a progress error is reported during a change.

2. **replicas**: When the object a ReplicaSet, determines how many pods should be created.

3. **RevisionHistoryLimit**: How many old ReplicaSet to retain for rollback.

4.**Selector**: **values ANDed together* all must be met for the replica to match.

5. **matchLabels**: requirements of the Pod selector. To further designate where the resource should be scheduled.

6. **Strategy** : A *Header* for values having to do with updating Pods.

7. **maxurge**: maximum number of pods over desired number of pods to create.

## Deployment Configuration Pod Template.
If you edit ANYTHING on the `spec.template` section of the **Deployment**, K8s triggers a rolling update.


*example*
```
template:
  metadata:
    creationTimestamp: null
    labels:
      app: dev-web
  spec:
    containers:
    - image: nginx:1.17.7-alpine
      imagePullPolicy: IfNotPresent
      name: dev-web
      resources: {}
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
    dnsPolicy: ClusterFirst
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext: {}
    terminationGracePeriodSeconds: 30
```
1. **template**: data passed to ReplicaSet to determine how to deploy an object.

2. **containers**: Key word to indicate values for the containers.

3. **imagePullPolicy**: Policy for the container engine about when and if an image should be downloaded or used from cache.

4. **name**: pod names.

5. **resources**: by default empty.

6. **terminationMessage**:where to output success or failure information of a container.

7. **dnsPolicy**:

## Deployment Configuration Status
### Status
`kubectl get deployment <deployment-name> -n <namespace> -o yaml`

- availableReplicas: value compared latter to the value at `readyReplicas` to determine if all replicas have been fully gernerated without error.

- observedGeneration: when zmb. updating a container, image, changing replica counts or modifying labels.

### How it works

- When you apply or edit a deployment the `metadata.generation` INCREASES, but the `status.obvservedGeneration` will not update immediately.

So if `metadata.generation` **equals** `status.ObservedGeneration`:
- The controller is up-to-date w/ (has processed) the changes and is ALSO consistent with the desired state.


## Scaling and Rolling Updates

There are mutable and immutable values. When you want to edit an immutable value, you would have to delete and recreate the deployment.

Ways to modify:

- `kubectl scale deploy/dev-web --replicas=4`

or editing the deployment object:

- `kubectl edit deployment dev-web`

## Deployment Rollbacks

When you update a deployment, Kubernetes creates a new **ReplicaSet** to manage the updated version of your application. The previous **ReplicaSet** are retained by default,and you can roll back of them if necessary.

Create a Deployment for app called 'ghost'

- `kubectl create deploy ghost --image=ghost`

- `kubectl annotate deployment/ghost kubernetes.io/change-cause="kubectl create deploy ghost --image=ghost"`
> The change cause is not necessary, but, is good practice as when you add annotations and run an annotation, you will see an output like this:

```
REVISION  CHANGE-CAUSE
1         kubectl create deploy ghost --image=ghost
2         kubectl set image deployment/ghost ghost=ghost:latest
```

### Rollback quick Lab
1. Create a Depoyment
- `kubectl create deployment my-app --image=nginx:1.19 --record`
Here  the `--record` flag automatically saves the command in the `change-cause` annotation

Verify the deployment
- `kubectl get deployments`

Check Rollout history:

- `kubectl rollout history deployment/my-app`

2. Update the deployment
Update the version of nginx image to update the deployment
- `kubectl set image deployment/my-app nginx=nginx:1.20 --record`

- `kubectl rollout history deployment/my-app`

3. Introduce a Bad Update with an incorrect version

- `kubectl set image deployment/my-app nginx=nginx:non-existent --record`

Check the failure:
- `kubectl get pods`

4. Rollback to the last working Version

- `kubectl rollout undo deployment/my-app`

Verify the pods are running

- `kubectl get pods`

Check the rollout history

- `kubectl rollout history deployment/my-app`


> You can also rollout to a specific Version instead of just the last working.
5. Rollback to a specific version.

- `kubectl rollout history deployment my-app --revision=3`

## Using DaemonSets
This controller ensures that a single pod exists on each node in the cluster. Every Pod uses the same image.

If a node needs to be deleted or added the replicaSet (*the controller*) will do so.

> **So to ensure knowledge, Deployments manage ReplicaSets --> ReplicaSets manage Pods used for scalable apps.**
> **DaemonSets manage pods direclty --> used for system-level services that should run on every node.**

DaemonSets ensures a particular container is always running on each Pod.


## Lab 1
