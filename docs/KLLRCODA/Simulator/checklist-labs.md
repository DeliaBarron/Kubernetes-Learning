# Checklist
# Kubernetes Hands-On Checklist

- [ x] Ingress exposing a service
- [ ] Create and apply Network Policies
- [ ] Apply Network Policies to a Deployment
- [x ] Create Deployments
- [ x] Configure Resource Management (requests and limits)
- [ x] Use StatefulSets with Resource Management
- [ x] Add VolumeMounts to all Deployments and **StatefulSets**
- [x ] Create a Service (NodePort type)
  - [x ] Link container/pod port to Service using `targetPort` and `nodePort`
- [ x] Use Helm to install a chart
- [x ] Install manifests without Helm (kubectl apply -f)
- [x ] Create Helm templates
  - x[ ] Ensure templates can install without including CRDs
- [x ] Enable communication between pods using Network Policies
- [ ] Install Calico for networking
- [ ] Configure CRDs for Calico if required
- [ x] Migrate fm standard Service to Gateway API
- [ ] Set up an ETCD Cluster ------------->
- [ x] Configure HorizontalPodAutoscaler
- [ x] Tubleshoot misconfigured or static pods
- [ x] Distribute resources evenly over nodes (e.g., 3 nodes)
  - [ x] Use StatefulSets with `resources.requests` set (limits optional)
- [ x] Install `cri-dockerd` with `dpkg -i`
  - [ x] Set required network environment variables in the config file
- [ x] Add a sidecar container for logs
  - [ x] Set the log path to `/path/logs`


----------------------
to do-labs in  chatgpt 
 different ways i could get assked to apply netpolicies to pods or deployments or enabling pods communication w netpols is it posible w daemonsets? stsfsets?? replicasets? idk

