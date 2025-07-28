# Workshop

## Alerts
### Memory Usage 

Cloudwifi: They run at night deployments at Trino
if it comes in the day
Go to the dashboards: Federix> Node of problem
trino and mongodb are expected


WE see tha topenEBD is usning alot of memory in one node only so we can:
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


### High loadin node worker

go to grafana >> see what pod is using more CPU
Create a ticket saying all the pods that are usin more cpu and ask what we do


This procedure is for when we have a constante cpu usage


###  PGPool
to many connections in Geo



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



# velero 
backups the resources files

Velero has crd that get all the reources and backups

so with velero CLI you can do 
- velero describe <backup>
- velero get <backup>
- k get backups


# restic
bavkups of data of the PVCs

mongo and maria and mysql: run a script to do a dump of the data





--------------------------------
improve alert to get the node name
just for Daisy do a table of what we manage on any cluster
all the alerts in the slack k8s moitoring are from all the namespaces WE manage.

From FREDERIX we have alerts from ALL namespaces
so we have frederix-monitoring an these alerts require a customer ticket or slack channel 

Work on K8s documentation



