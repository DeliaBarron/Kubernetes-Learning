# Services
https://medium.com/devops-mojo/kubernetes-service-types-overview-introduction-to-k8s-service-types-what-are-types-of-kubernetes-services-ea6db72c3f8c

Are what connect the Pods with each other or outside of the cluster.
**Typically using Labels, the refreshed Pod is connected and the microservice continues to provide the expected resource via an Endpoint**.


`kube-proxy` watches new services and endpoints being created on each node.
Services provide automatic load-balancing matching a label query.



## Service Update Pattern
Labels can be dynamically updated for an object.

So when rolling to a different version, k8s would deploy the new pods and then you would have v1 and v2 using the same service because of the poorly set labels. So to avoid both versions to get loadbalance at the same time from the service you should:

1. Deploy new Pods w a different /extra label
2. Wait for the new pods to start and become ready.
3. Update the service to change its label to only function w the newlex created pods (v2)
4. The service sends only to v2 Pods and the v1 are now in idle to be safley deleted. 

If you have a deployment, say NGINX, then you could create a service for it by exposing it: 
`kubectl expose deployment/nginx --port=80 --type=NodePort` --> Create a Service fo an existing pod or deployment

this would create something like this: 

```
NAME        TYPE       CLUSTER-IP  EXTERNAL-IP  PORT(S)
nginx       NodePort   10.0.0.112  <none>       80:31230/TCP   
```

Which means : 
port:nodePort/protocol --> 80:31230/Tcp
- 80: Service port: the port inside the cluster that other Pods use to talk to the Service. 
- 31230 this is the NodePort: a port exposed on every worker node, allowing acces to the service from outside the cluster.

> The 80 in 80:31230/TCP is the port the Service forwards traffic to, and it should match the targetPort (which often matches the container's port) — in your case, probably nginx's port 80.

## Service Types

- **ClusterIP**: Service default. Only provides ACCESS INTERNALLY. so it exposes the service within the k8s cluster.

Kubernetes assigns this Service an IP (The *cluster IP*). The controller for that Service continuosly scans for Pods that match its label selector.
Services are assumed to have virtual IPs only routable within the cluster network.



- **NodePort**: Exposes the service on every Node
- **LoadBalancer**: 
- **ExternalName**: It has no selectors, ports or endpoints. Redirection happens at a DNS level, not proxy or forward.

- `kubectl proxy`: **creates a local service to access a ClusterIP. Useful for troubleshooting or dev work.**


A Service is an operator running inside `kube-controller-manager` sending API calls to the network plugin and the `kube-proxy` pods running all nodes.

Kube-proxy is configured via a flag durint initialization such as **mode=iptables** or opvs or userspace.


The service creates an **Endpoint operator** which queries for the ephemeral IP adresses of pods with a particular label.

The service operator and the endpoint op. work togther to manage firewalls using `iptables`.

- when a **NodePort** request is made. The Cluster IP is created,  then  a high port is created and a firewall rule is sent so that port is sent to the persistent IP.

An ingress controller is a microservice running in a pod listening to a high port on whichever node the pod may be running



`kube-proxy` --> run on every pods, manage tables, it routes traffic to the healthy pods on the node. handles lots of the routing behind Services. *basically writing IP tables rules*

`Ingress`: router for http/s trafic. Works with a controller like **Traefik**.



```
EXTERNAL TRAFFIC
    ↓
Ingress Controller (path-based routing)
    ↓
ClusterIP Service → kube-proxy (load balancing)
    ↓
Pod IP (routed via CNI networking)

```

# LAB 1 
Services declare a policy to access a logical set of Pods. tipixally assigned with labels.

When creating pods form a deployment you can have multiple labels
- the first is to define the label od the deployment itself
- the first matchLabel is the one the deployment should match by managing the pods. when the pods are running the deployment will manage those with this label
- the label of `nodeSelector` is the label to use when choosing where to schedule this pods. This label should be one in the node´s label.

create labels :
- `k label node <node-name> <label>`
delete a label
- `k label node <node-name> label-` //adding the - deletes the label

once the deploymeny is running we can create a service to expose the pods.
As we can see, the deployment declares the containers inside the pod will listen on 8080 BUT THAT DOESN EXPOSE THEM TO THE OUTSIDE, so we nned to create a service or ingress


- `k expose deployment deploy-name`
- verify: 
`k get ep deploy-name`

this is per default a ClusterIP.
You can test a cluster P service by getting into the pod and doing a curl to the clusterip plus listening port




# LAB 2
when you work with NodePort after exposing the depoyment:
`k expose deployment <name> --type=NodePort --name=<service-name>`

you can see the service has all pods as endpoints.
the kube-proxy of each node intercepts the traffic on the pod and forwards the traffic to the pods on their targetPort.