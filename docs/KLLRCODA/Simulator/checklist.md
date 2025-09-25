# Checklist
# Kubernetes Hands-On Checklist

- [x ] Ingress exposing a service
- [x ] Create and apply Network Policies
- [x] Apply Network Policies to a Deployment
- [x ] Create Deployments
- [ x] Configure Resource Management (requests and limits)
- [ x] Use StatefulSets with Resource Management
- [ ] Use both Deployments and StatefulSets together
- [ ] Add VolumeMounts to all Deployments and StatefulSets, daemonsets
- [ x] Create a Service (NodePort type)
  - [ ] Link container/pod port to Service using `targetPort` and `nodePort`   link pod?
- [ x] Use Helm to install a chart
- [x ] Install manifests without Helm (kubectl apply -f)
- [ x] Create Helm templates
  - [ x] Ensure templates can install without including CRDs
- [x ] Enable communication between pods using Network Policies
- [ x] Install Calico for networking
- [ x] Configure CRDs for Calico if required
- [ ] Migrate fm standard Service to Gateway API
- [ ] Set up an ETCD Cluster
- [x ] Configure HorizontalPodAutoscaler
- [ ] Troubleshoot misconfigured or static pods
- [ ] Distribute resources evenly over nodes (e.g., 3 nodes)
  - [x ] Use StatefulSets with `resources.requests` set (limits optional)
- [ x] Install `cri-dockerd` with `dpkg -i`
  - [ x] Set required network environment variables in the config file
- [x ] Add a sidecar container for logs
  - [ x] Set the log path to `/path/logs`


----------------------
to do-labs in  chatgpt 
 different ways i could get assked to apply netpolicies to pods or deployments or enabling pods communication w netpols is it posible w daemonsets? stsfsets?? replicasets? idk




What is the difference of cluser role binding and a role binding?

We can only create one cluster role or multiple roles for different namespaces.
