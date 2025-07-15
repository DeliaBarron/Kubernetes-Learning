# Logging and Troubleshooting
Metric Server is what collects key metrics of the nodes and applications 
Fluentd can be a useful data collector for a unified logging layer

## basic troubleshooting steps

If you dont have logs, you can deploy a sidecar container in teh pod to generate and handle logging. The next place.

STEPS:
- Errors on the CLI
- Pod logs and the state of Pods
- Use shell to troubleshoot Pod DNS and network
- Check node logs for errors, make sure there are enough resources allocated.
- RBAC
- calls to the kube-apiserver
- Enable auditing
- Inter-node network issues, DNS and firewall
- Control Plane server controllers 

u cozl either do: 
- `kubectl logs <pods/deploy/...>`  conaitner level
- `journalctl -u kubelet`   nodes level when suspected issues with the kubelet, container runtime, or other system services.



- 
| Problem / Component                                    | Where to Look                 | Tools / Commands                                                                             |
| ------------------------------------------------------ | ----------------------------- | -------------------------------------------------------------------------------------------- |
| 🔧 **Kubelet not working**                             | Node system logs              | `journalctl -u kubelet`                                                                      |
| 📦 **Container runtime issues** (containerd or Docker) | Node logs                     | `journalctl -u containerd` or `journalctl -u docker`                                         |
| 🗂️ **Static Pods (control plane)** not running        | Node filesystem               | Check `/etc/kubernetes/manifests/` for static Pod YAMLs                                      |
| 📋 **Pod won't schedule**                              | Kubernetes events             | `kubectl describe pod <pod>` <br> `kubectl get events --sort-by=.metadata.creationTimestamp` |
| 🚫 **Pod stuck in Pending**                            | Node status, scheduler        | `kubectl describe pod <pod>` <br> Check taints: `kubectl describe node <node>`               |
| 💥 **Pod won't start / crashing**                      | Pod logs                      | `kubectl logs <pod>` (use `-p` for previous container)                                       |
| 📜 **YAML syntax errors (manifest rejected)**          | Kubernetes API feedback       | `kubectl apply -f file.yaml` (shows error)                                                   |
| 🛑 **API server not responding**                       | Control plane static Pod logs | `docker ps -a` or `crictl ps -a` <br> Check `/etc/kubernetes/manifests/kube-apiserver.yaml`  |
| ⚖️ **Scheduler not scheduling Pods**                   | Scheduler logs (static Pod)   | `docker ps` / `crictl ps` <br> `kubectl logs -n kube-system kube-scheduler-<node-name>`      |
| 🧠 **Controller Manager issues**                       | Logs (static Pod)             | `kubectl logs -n kube-system kube-controller-manager-<node-name>`                            |
| 🗄️ **etcd issues**                                    | etcd static Pod logs          | `kubectl logs -n kube-system etcd-<node-name>`                                               |
| 🔒 **Certificates expired / issues**                   | Node filesystem               | `/etc/kubernetes/pki/` <br> Check `openssl x509 -in cert.pem -noout -text`                   |
| 🔑 **Kubeconfig problems**                             | Kubeconfig file               | `$HOME/.kube/config` or `/etc/kubernetes/admin.conf`                                         |
| 🌐 **DNS not working**                                 | CoreDNS logs                  | `kubectl logs -n kube-system -l k8s-app=kube-dns`                                            |
| 🧭 **Network plugin not working**                      | Pod status and CNI config     | `kubectl get pods -n kube-system` <br> Check `/etc/cni/net.d/`                               |




