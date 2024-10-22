# Troubleshooting / Tickets
You will find some context information and then the work around if provided.

## Secrets in K8s

Sealed secrets is a k8s controller and CLI that encrypts so **it can only be decrypted by the controller which has the private key**.

Secrets are tje resource that manages the deployment of sensitive information.

<span style="color:mediumslateblue";s>Secrets can be mounted as data volumes or exposed as environment variables to the containers in a K8s Pod.</span>

The data stored is encoded using Base64, so from a **Secret** like this:
```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: d2VsY29tZSB0bw==
  password: Zm94dXRlY2g=
```

you can easily decode with:

` echo -n Zm94dXRlY2g= | base64 -d`

Because of this you should then:

- Enable encryption at rest
- Enable RBAC rules to access secrets in a cluster
- Restrict Secrets to specific containers
- Consider using external Secret store providers

## Sealed Secrets
Sealed Secrets can be decrypted **ONLY** by the controller running in the target cluster.
You will also need `kubeseal` which retrieves the public key for encryption purposes.

> The private key is only available to the Sealed Secrets controller on the cluster, and the public key is available to the developers. This way, only the cluster can decrypt the secrets, and the developers can only encrypt them.

### CMS Deployments
As soon as they have a new customer, we need to create their users in MinIO, buckets and their `strap-instance`.

- At their cluster cloudwifi-prod thei have a namespace called `cloudwifi-cms` that they use for CMS to manage the pics and files for the login pages they provide.

- Confluence: they use it for documentation.
they push their secrets on gitlab, so they do sealed secrets.

- when you create a sealed secret you specify the namespace of the sealed secrets controller that will ve able to dencrypt.

- to create the sealed we gave the command the values we want to encrypt with the key included. and creates the file of the sealed-secrets. when running the command to create the sealedsecrets make sure you generate passwords or values or if the customer needs specific values, to run the command with the correct values depending on the ticket info.
(In this case, Frederix provided the userPassword values.)

>One strapi-instance, is one customer and its own Minio or bucket. Each bucket has a policy.
>One strapi-instance, is one customer and its own Minio or bucket. Each bucket has a policy.
>Minio create  bucket steps are in confluence documentation.

In order to create the bucket (in summary) you need to get the secrets and then inside their MinIO instance, then create a bucket in the MinIO UI. The password for the Frederix user is in their documentation too.

- We copied a last strapi-instance file and then do the corresponding changes like the `strapi-id` in the whole file (the customer ID is the strapi-id)

-once the buckets are created with this user and password values for each customer/ strapi id we create the DB on postgress (documentation id confluence too) *see postgres documentation for this*

- when running the postgress command ensure the db were created (thay have the srtrapi name on the table) and then to apply this files we need to create a merge request to their repository.

- -MR: we create a new branch, "new-strapi-instannces", den push to this new branch with the commint message of the strapi-ID of the instances.

- Go to thier argoCD gitlab to verify the push of the new files.

## Geo mobile DB cluster
*for postgres db*

they have High Availability in the prod and staging
but the issue is that in staging we have 2 primary pods for db instead of only one primary and 2 slaves. THis is due a bug in postgres we still dont have this clear

documentation to see the sstatus of the DB replica status: `https://gitlab.admin.hundertserver.com/kubernetes/geo.fra1/-/tree/main/postgis-staging?ref_type=heads#get-repmgr-status`

After checking the status on the 3 pods you can see in which pod relies the error, as one of this will double the information of which one is the percieved as the primary one.

### solution
restart / delete the pod

## Upgrade vault

in Vault we have
we actually didnt have resources


so he scale down the (scale --replicas 0 ) pods we are not using (0/2 for example) and doing this we get more resources free to upgrade vault in the worker nodes

`kubectl exec vault-0 -- vault operator raft list-peers`
we execute this inside the vault-0 pod and see the 3 pods/ containers runing vault in this 3 -piece cluster.
you would have to run this list peers command for all 3 vault pods to ensure the information is being seen the same on all the pods.


### Difference between delete and scale down
- **scale down pods:** changes the deployment info to the number of replicas u specify with `--replicas` flag.
- **delete pod:** as soon as you delete a pod a pod gets terminated k8s will terminate the pod but at the same time recreate it cause the replicaset has 1 pod set so it has to have a pod created.


## Joining a new worker node

- staging cluster is running in hetzner where we have a 'Hetzner robot interfaceaccount.
- there we can see the worker nodes and the control plane  for `cloudwifi` Frederix.


you log in to another worker to compae values for the new
-  got to HS+ > servergrouups > cloudwifi > staingin> workers and add a new VM with the new ip private and public ip that hetzner gave us.

_ go to the other past worker and check for the history to see what was done to set up

- update and upgrade
- install vim
- add /etc/hosts : add control plane ip and hostname and the hostname and ip of the new worker itself to its own /etc/hosts
- add the monitoring hostname to /etc/hosts too
- add puppetserver (puppet1.bb) to the etc/hosts cause we dont have vpn so we have to access puppet from internet

```
10.0.0.6 worker4.cloudwifi-staging.frederix.srservers.net worker4
127.0.0.1 localhost

10.0.0.2 controlplane1.cloudwifi-staging.frederix.srservers.net controlplane1

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

37.61.211.3 puppet1.bb.srservers.net puppet
138.201.32.164 mon1.hub1.srservers.net mon1

```
- set hostname: `hostnamectl set-hostname worker4.cloudwifi-staging.frederix.srservers.net`
- run a reboot to confirm: `$ reboot`
- Edit the cloudinit configuration file and comment the lines to avoid hostname update and etc/hosts file updates:
 `vim /etc/cloud/cloud.cfg`

 ```
 cloud_init_modules:
 ...
 # -update_hostname
 # -update_etc_hosts
 ...
 ```

- install puppet agent:
    - `wget https://apt.puppet.com/puppet7-release-bullseye.deb`
    - `dpkg -i puppet7-release-bullseye.deb`
    - `apt update`
    - `apt install puppet-agent`
    - `ping puppet`  # puppet as it is set like that in /etc/hosts

- Copy the HS+ server group UUID to the file /root/sr_uuid `
    - `echo "678959d4-6528-4b55-81f1-ce2e0e21d053" > sr_uuid`

- swapoff -a   # as k8s doesn support it

- as puppet is accessed from the public network we have to do some firewall rules
- in `fw1.hub2` server we have the forwarding rules for accessing the `puppet1.bb` server from a public network.

- `ssh fw1.hub2`
- list the previous rules for the other workers, copy and edit them with the next information:
    - `sh conf c`
    - rule id has to change/ increased by 10
    - destination addres: puppet1.bb IP `37.61.211.3`
    - IP of the source `eth0`: (check on the new worker server by doing `ip addres show`)

To set this rules you should run:
```
$ config
- paste the new rules
$ commit
$ save
```

update the same k8s version on the new worker node:
```
- apt-mark unhold kubeadm && apt-get update && apt-get install -y --allow-downgrades kubeadm=1.26.3-1.1 && apt-mark hold kubeadm
- apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y --allow-downgrades kubelet=1.26.3-1.1 kubectl=1.26.3-1.1 && apt-mark hold kubelet kubectl


```

k8s control plane creates token to join workers but this token is only temporarily so we need the command to print this token even when the time is out:
`kubeadm token create --print-join-command --node-name -host-name  or something like that` this has to be run in the control plane to get the token for the command that we are gonna run as follows in the worker node.

- this runs in the worker:
kubeadm join api.cloudwifi-staging.frederix.k8s.hundertserver.com:6443 --token $TOKEN --discovery-token-ca-cert-hash $CERT_HASH --node-name `hostname -f`



## Upgrade Kubernetes
kubectl get nodes -o wide

controlplae1
- goes to hs+
- servergroup fro master 54
-  change the k8s version on workers and the controlplane  to 1.27
- cat source.list to see the previous k8s version
then run puppet agent -tv and confirm that the 1.27 is there now
- apt update
- `apt-cache madison kubeadm:` we see the latest stable version for the actual repo that u have/u can use (the one at the top) this is the version we will write to the commands of the `apt mark hold...` for each packages
so do the madison command for kubeadm and check the version , compare the version we have and if different, run the mark hold command with the corresponding version for each packafge (kubeadm, cni, cri-tools).


- do the madison command for kubeadm, kubernetescni , cri-tools
- Use this version to replace the value of the versions on the apt install commands
-

### CNI
- apt-mark command
- kubeadm upgrade plan: check if the cluster is ready fot the upgrade and if yes it gives u the command  to do so. and the table of what is gonna be upgraded
- run the command that it gives u (upgrade apply)

> kubeadm needs to be upgrade to be able to able to be drained


### kubelet and kubectl
we need to drain the node to make no pod to be running in  the node. K8s wont scheduled pods on this node anymore by running the `drain` command
- run the upgrade commands
- run the uncordon to enable the node


### now we change to workers
run the commands
- kubeadm upgrade node # this is instead of the plan. plan is ONLY for the main control plane
- delete ampdir data is needed for the workers only
- drain
- uncordon until the node shows `Ready` status
-

verify that all the pods in all namespaces are running with `kubectl get pod --all-namespaces -o wide | grep worker1` or 2 or control plane to see that the upgrade we did in the specific node was done sucessfully

>restarting the service daemon is only for the kubelet service. Is a service running on each worker.

> do this proces for controlplane and then the workers and once you are done you have to repeat the process for the next k8s version



### Upgrade order of commands

```
apt update
apt-mark unhold cri-tools kubernetes-cni && apt-get update && apt-get install -y cri-tools=1.26.0-1.1 kubernetes-cni=1.2.0-2.1 && apt-mark hold cri-tools kubernetes-cni
apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.26.15-1.1 && apt-mark hold kubeadm
kubeadm upgrade plan
kubeadm upgrade apply v1.30.4


kubectl drain <node-to-drain> --ignore-daemonsets
apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.26.15-1.1 kubectl=1.26.15-1.1 && apt-mark hold kubelet kubectl
systemctl daemon-reload && systemctl restart kubelet
kubectl uncordon <node-to-uncordon>


Workers:
apt-mark unhold cri-tools kubernetes-cni && apt-get update && apt-get install -y cri-tools=1.26.0-1.1 kubernetes-cni=1.2.0-2.1 && apt-mark hold cri-tools kubernetes-cni
apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm=1.26.15-1.1 && apt-mark hold kubeadm
kubeadm upgrade node
(at localhost) kubectl drain <node-to-drain> --ignore-daemonsets --delete-emptydir-data
apt-mark unhold kubelet kubectl && apt-get update && apt-get install -y kubelet=1.26.15-1.1 kubectl=1.26.15-1.1 && apt-mark hold kubelet kubectl
systemctl daemon-reload && systemctl restart kubelet

## Check if the node is ready
(on local)kubectl uncordon <node-to-uncordon>


------------NOTES -----------------------------
CONTROLPLANE1
kuber8 to 1.26 in HS
puppet agent -tv


kubeadm upgrade plan
Got the kubeproxy error> went to kube-system ns > deleted the key that the error show> kubectl edit cm kube-proxy > kubectl rollout restart daemonset.apps/kube-proxy
Once the pods got the new edit oapt-mark unhold cri-tools kubernetes-cni && apt-get update && apt-get install -y cri-tools=1.26.0-1.1 kubernetes-cni=1.2.0-2.1 && apt-mark hold cri-tools kubernetes-cni



dns utils is use for debuggin
```



## Upgrade resources
- Drain the node
- Proxmox UI u change the resource to what they need
- In proxmox u reboot the machine
- back in k8s uncordon

> For geomobile we need a resolve.conf file in the worker node to be able to start pods



For data bases, we go to the customer docu > postgres >
rempgr  > so you run the repmgr command on the postgres pod to see if the cluster is ready

once that is running in all postgres pods you can go ahead with the second worker so again:
- k drain worker2  ....
- if we get an error od a pod not with a deploymet then we delete the pod,
if the error continues saying the pod could note get evicted, we need to do a rollout to delete it but create in another worker.


- go to proxmox, change resources from the secon worker2 > ssh to this worker and shutdown and start again  (from terminal isbetter)
- do the repmgr commmands
- k uncordon
- k get nodes to see the are starting



