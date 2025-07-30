# Checklist
# Kubernetes Hands-On Checklist

- [ ] Ingress exposing a service
- [ ] Create and apply Network Policies
- [ ] Apply Network Policies to a Deployment
- [ ] Create Deployments
- [ ] Configure Resource Management (requests and limits)
- [ ] Use StatefulSets with Resource Management
- [ ] Use both Deployments and StatefulSets together
- [ ] Add VolumeMounts to all Deployments and StatefulSets
- [ ] Create a Service (NodePort type)
  - [ ] Link container/pod port to Service using `targetPort` and `nodePort`
- [ ] Use Helm to install a chart
- [ ] Install manifests without Helm (kubectl apply -f)
- [ ] Create Helm templates
  - [ ] Ensure templates can install without including CRDs
- [ ] Enable communication between pods using Network Policies
- [ ] Install Calico for networking
- [ ] Configure CRDs for Calico if required
- [ ] Migrate fm standard Service to Gateway API
- [ ] Set up an ETCD Cluster
- [ ] Configure HorizontalPodAutoscaler
- [ ] Tubleshoot misconfigured or static pods
- [ ] Distribute resources evenly over nodes (e.g., 3 nodes)
  - [ ] Use StatefulSets with `resources.requests` set (limits optional)
- [ ] Install `cri-dockerd` with `dpkg -i`
  - [ ] Set required network environment variables in the config file
- [ ] Add a sidecar container for logs
  - [ ] Set the log path to `/path/logs`


----------------------
to do-labs in  chatgpt 
 different ways i could get assked to apply netpolicies to pods or deployments or enabling pods communication w netpols is it posible w daemonsets? stsfsets?? replicasets? idk

