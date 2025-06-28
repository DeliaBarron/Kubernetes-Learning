# Services
https://medium.com/devops-mojo/kubernetes-service-types-overview-introduction-to-k8s-service-types-what-are-types-of-kubernetes-services-ea6db72c3f8c

Are what connect the Pods with each other or outside of the cluster.
**Typically using Labels, the refreshed Pod is connected and the microservice continues to provide the expected resource via an Endpoint**

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

- **ClusterIP**: Service default. Only provides access internally. so it exposes the service within the k8s cluster.

- **NodePort**: Exposes the service on every Node
- **LoadBalancer**: 
