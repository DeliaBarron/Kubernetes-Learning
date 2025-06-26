# API crash
the `/etc/kubernetes/manifests/kube-apiserver.yaml` has a missconfiguration (wrong argument)

> As this is a kubeadm k8s instance all the controlplane are running here in the same node so thats why we find it under /etc/kubernetes.... but in HS+ as it is a cluster runnning the cp on separate vms we wont be able to find it if we do /etc/kubernetes/manifests....

You can see if you are using a managed provider: `kubectl get node -o wide`

- Open the apiserver file, check for wrong arguments/values
- Erase them and see the pods on the kube-system namespaces

You are running `k -n kube-system get pods` to see there is an issue or error

### Logs
- `/var/log/pods/kube-system_kube-apiserver-controlplane_23be7b86cf45f7670bbd5ac4eedafea8/kube-apiserver`

- `/var/log/containers`
- `journalctl | grep apiserver` # to chek for file syntax error maybe
- `cat /var/log/syslog | grep apiserver` 
- `tail -f /var/log/syslog | grep apiserver`


### Troubleshooting
try to get the resources:  `k -n kube-system get pods`

check the logs and see what yaml has teh problem.
edit the yaml

check if the containers are getting restarted or down : `crictl ps`

if you dont see under /var/log/containers the apiserver files then is another sign the apiserver is not running


if you get this error:
> The connection to the server 172.30.1.2:6443 was refused - did you specify the right host or port?

check under  `/etc/kubernetes/manifests/kube-apiserver.yaml` that the --etcd-servers have the correct port.
You can check the  `/etc/kubernetes/manifests/etcd.yaml` to check the port where etcd is running

# API server
checked the /etc/kubernetes/manifests/api for the logs of the api 

keep in mind the ports:
 API server's port 6443
 etcd's ports 2379-2380
 Kubelet's port 10250
