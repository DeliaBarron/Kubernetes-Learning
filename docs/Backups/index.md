# Velero Backups


check monitoring of velero in prometheus:
    - Go to the prometheus of the customer, search for velero and check that te rules are running correctly
    - go to the velero namespace of the prod or staging cluster and run: `velero  get backup`
    - den  you will see the last backups of velero and then you can select a name of this (the last one)
    and run a `velero describe backups <name-of-one-backup> --details`
    this will show a deeper description of the backup up object, where we see what was backedup.

    - kubectl get pvc --all-namespaces:
 this checks what pvs we have in the cluster


## Ceph
storage over network.
nd is used on the shared clusters



## OpenEBS
Local storage in the fphysical machines where we have replications or redundancy. if one if down it will use the other ones but this one that is down will remaing pending until it gets fixed.
for private clusters / customers.


<span style="color:red;">why zmb geo has as storaga classes both openebs and ceph?</span>



staging.pro54:
 - we have monitoring
 - we have backups for acme-dns

 restic Backups:
  Completed:
    cert-manager/acme-dns-778c7db5d-9g9wr: acme-dns-data-vol

Namespace:     PVC Name:

cert-manager   acme-dns-pvc
mongodb        mongod-data-db-rs0-0
monitoring     prometheus-prometheus-kube-prometheus-prometheus-db-prometheus-prometheus-kube-prometheus-prometheus-0
