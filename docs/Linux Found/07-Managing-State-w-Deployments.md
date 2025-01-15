# Deployments
When added to the cluster, the controller will create a ReplicaSet and a Pod automatically. The **containers**, their **settings** and applications can be modified via an update, which generates a new **ReplicaSet** which generates new Pods with the new configurations.

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