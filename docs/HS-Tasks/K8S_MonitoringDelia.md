# Workshop

## Alerts

### Backup
#### Trino /postrges 
Error at backup, pod on ChrashLopp or failing

For postgres we set up the backups scripts ourselves and we created the docker (built) image. When the backup-script is done we dump the data to minio.
To run the script we need the image to use the aws cli to dump it to our buckets.

We have the postgres backup image on Gitlab container registry. This registries have a token and is on the secrets for trino and postgres. 
You can verify there the expiry date for them on gitlab or by doung `docker login` (user and password are at secret as well).


Create secret for registry access:

```
kubectl create secret docker-registry cloudwifi-staging-image-pull --docker-server=registry.admin.hundertserver.com:443 --docker-username=cloudwifi-staging-image-pull --docker-password=$PASSWORD
```
Don't forget to delete the old one.


After creating the new secret with the new token you can go ahead and delete the backup pods at postgres namespace.

> **The same process is for both Trino namespaces backup issues.**



## CPU Overcommited
This alert doesn't look at actual CPU or disk usage on the node - it only cares about CPU requests vs allocable CPU on the node.

as it is Kube  Rule is not about pne single node. Is a cluster node alert.


### Memory Usage 

Cloudwifi: They run at night deployments at Trino
if it comes in the day
Go to the dashboards: Federix> Node of problem
trino and mongodb are expected


WE see that openEBS is usning a lot of memory in one node only so we can:
- REstart/delete Pod

### Disk Usage in Node

 - Disk usage in node 10.182.101.54:9100 in disk /dev/sdb is higher than 75%

- Connect to the node
- /var is in k8s out main partition 
-  check where is the main load anyways: `df -h`
- `cd /var`
- `du -sch *`
- see where u have the most usage then `cd ` to that directory again and run `du -sch *` again 

#### Pro54
In Master.pro54 they tend to have a lot of images. 
This images are located under `/var/lib/containerd` so if this is the directory that is being filled up, crete a ticket asking the customer how to proceed.
> Ticket Example: Ticket#202507245300199

If the answer is to clean the images that are not used the following commands are needed. 

- on the node run `crictl images`
- here you can see the size of the images and how many there are. (**also usefull for Ticket information for the customer**).
- in order to get rid of unused images run `crictl rmi --prune`
- you can get more information with : 
    - `crictl --help`
    - `crictl rm --help`


### High loading node 
### workers

go to grafana >> see what pod is using more CPU
Create a ticket saying all the pods that are usin more cpu and ask what we do


This procedure is for when we have a constante cpu usage

### HUB2 node  usage to high.
At Hub2 ProxySQL is the cause.

- Check the instance that is getting high on load.
- Restart ProxySQL by deleting all the pods of that node trigering this high usage:
- `k get pod -o wide` at `mysql-production`



###  PGPool
to many connections in Geo

### PVC getting full
We had the prometheus monitoring pvc getting full and was causing alerts of kubelet, kubeAPI and more as prometheus was unable to detect and do scraping anymore. So metrics we getting lost.

Check the mountPath of the pvc on monitoring namespace:
- `k get pod prometheus-pod -oyaml`
- Execute into the pod and go to the mountPath to examinate the usage with `du -sch *`
- Compare this values and examinate them against the pvc total capacity. (`k get pvc`).

- If the pvc is using PV of type rbd we can increase the disk capacity. 

> **Openebs** PV can't be modified as the **rbd** PV's. 



### Opensearch

Each Pods has logs
they get lost when they get restared so they get saved in opensearch
For each customer we have a tenant so they can see their logs
WE can filter time, customer cluster and pod name /namespace / deployment



### OOMkileed pod requires a customer ticker to see why it was killed

## troubleshooting
### etcd
Other alert we get and we cant do much of it: add the defragmented command of driton

- compare etcd data hash at the beginning
```
kubectl -n kube-system exec  etcd-controlplane1.staging.hs.srservers.net -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint hashkv
```

- Then run etcd defragmentation. this will run for all members of the cluster.

```
kubectl -n kube-system exec etcd-controlplane1.staging.hs.srservers.net -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key defrag --cluster
```
then u will see the hash value changes.




# restic
bavkups of data of the PVCs

mongo and maria and mysql: run a script to do a dump of the data






# velero 
backups the resources files

Velero has crd that get all the reources and backups

so with velero CLI you can do 
- velero describe <backup>
- velero get <backup>
- k get backups



-------------------------------
improve alert to get the node name
just for Daisy do a table of what we manage on any cluster
all the alerts in the slack k8s moitoring are from all the namespaces WE manage.

From FREDERIX we have alerts from ALL namespaces
so we have frederix-monitoring an these alerts require a customer ticket or slack channel 

Work on K8s documentation

----
# K8s Troubleshooting
## PVC FULL
k get pvc

for the rbd storageclass

k describe storaclass + name of this

and we can see the allow extension :  k describe storageclasses.storage.k8s.io rbd.ssd.k8s.daisy.fra1  and we can see : AllowVolumeExpansion:  True

then edit the pvc and expand the storage to what we need

then delete the pod is using the pbv and then we can do k get pvc to see the capacity changed 
then we can get /execute the pod that used this pvc and we can check the du sch* so we can see the size also changed there.

