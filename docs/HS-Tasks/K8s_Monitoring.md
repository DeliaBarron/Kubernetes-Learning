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

### etcd
### etcdDatabaseHighFragmentationRatio 
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
- Improve alert to get the node name
- For Daisy do a table of what we manage on the cluster 
- Work on K8s documentation



# Troubleshooting /tickets
Traefik pods: they are just forwarding and managing the egress so if the pods are having some requests 404 is weird as nothing should try to write to Traefik pods as traefik just forwards.

Prometheus is scraping the data. release promethteus label makes prometheus to search for data in this places, this is done through the metrix service with the port named metrics too.
THis service (traefik-service)targetshas as endpoint the traefik pods and each traedik pod has its own different port

2 traefik Pods and multiple ports open as in normal life


Traefik: manages the public network to the internal cluster network

enableRemoteWriter

missing conf we changed and is f
