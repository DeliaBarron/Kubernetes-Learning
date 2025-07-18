# Workshop

## Alerts
### Memory usage is too high in instance

Go to the Grafana K8s dashboards > Kubernetes > Kubernetes Resources

- Check `Memory Usage pre Container` to see if theres an unusual Pod containers using extra memory
- Restart the pod
- Create a customer ticket to inform and ask what actions should be taken.

#### Pod
Opensearch for logs of resources

> OOMkilled pod requires a customer ticker to see why it was killed

### etcdDatabaseHighFragmentationRatio### etcd
- compare etcd data hash
```
kubectl -n kube-system exec etcd-controlplane1.cloudwifi-csn-prod.srservers.net  -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key endpoint hashkv
```
- run etcd defragmentation for all members of the cluster

```
kubectl -n kube-system exec etcd-controlplane1.cloudwifi-csn-prod.srservers.net -it -- etcdctl --write-out=table --cluster  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/peer.crt --key=/etc/kubernetes/pki/etcd/peer.key defrag --cluster
```


### VeleroBackupPartialFailures
- backups the resources files
Velero has crd that get all the reources and backups
In the CLI: 
- velero describe <backup>

> restic
> backups of data of the PVCs
> mongo and maria and mysql: run a script to do a dump of the data

### Notes
- all the alerts in the slack k8s moitoring are from all the namespaces WE manage.
- From FREDERIX we have alerts from ALL namespaces
- Frederix-monitoring an these alerts require a customer ticket or slack channel 

## To Do's
- improve alert to get the node name
- For Daisy do a table of what we manage on the cluster cluster
- Work on K8s documentation



