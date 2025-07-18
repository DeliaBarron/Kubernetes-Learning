# Workshop

## Alerts
### Memory Usage 

Cloudwifi: They run at night deployments at Trino
if it comes in the day
Go to the dashboards: Federix> Node of problem
trino and mongodb are expected


WE see tha topenEBD is usning alot of memory in one node only so we can:
- REstart/delete Pod


## High loadin node worker

go to grafana >> see what pod is using more CPU
Create a ticket saying all the pods that are usin more cpu and ask what we do


This procedure is for when we have a constante cpu usage


##  PGPool
to many connections in Geo



### Opensearch

Each Pods has logs
they get lost when they get restared so they get saved in opensearch
For each customer we have a tenant so they can see their logs
WE can filter time, customer cluster and pod name /namespace / deployment



## OOMkileed pod requires a customer ticker to see why it was killed


Other alert we get and we cant do much of it: add the defragmented command of driton:
## troubleshooting
### etcd
- compare etcd data hash
```
kubectl -n kube-system exec etcd-controlplane1.cloudwifi-csn-prod.srservers.net  -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint hashkv
```
- run etcd defragmentation for all members of the cluster

```
kubectl -n kube-system exec etcd-controlplane1.cloudwifi-csn-prod.srservers.net -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key defrag --cluster
```


# velero 
backups the resources files

Velero has crd that get all the reources and backups

so with velero CLI you can do 
- velero describe <backup>


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



