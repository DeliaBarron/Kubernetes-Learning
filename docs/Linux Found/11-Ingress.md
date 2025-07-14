# Ingress

> Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster.

Just as we use Service to expose a containerized app outside the cluster, we use **Ingress Controllers and Rules** but Ingress is way mor efficient as we can route traffic based on the reques host or path. this allows the centralization of many services to a single point.

Ingress Controllers (such as Traeffik), use rules to handle the traffic to and from the cluster. Rules are created with `kubectl`

when you create that resources it reprograms and reconfigures your Ingress Controller to allow traffic to flow from the outside to an internal service. You can leave a service as a ClusterIP type and define how the traffic gets routed to that service using an Ingress Rule.

The Ingress is a daemon runnning in a pod which watches the **/ingress** endpoint on the API server, which is found unter the **networking.k8s.io/v1** 

When a pod is created that mathces the Service selector, k8s automatically adds this Pod as an **endpoint** for that service.

**kube-proxy** updates the networking rules including iptables.
when someone sends requests to the Service IP. When a ingress controller is in front od the cluster, it can forward external traffic to the correct Service.

YOU CAN HAVE MULTIPLE BACKEND PATHS TO A SINGLE IP /HOST


## Creating an Ingress Rule
- Create a Pod /deployment
- Expose the service 

```
Browser → ghost.192.168.99.100.nip.io → DNS resolves to 192.168.99.100
→ Ingress controller gets request
→ Matches Host: ghost.192.168.99.100.nip.io
→ Forwards to Service: ghost, port 2368
→ Service routes to a Pod (e.g., Ghost blog app)
```


## Ingress Limitations
- HTTP Heades
- HTTP methods
- Cookies


## Gateway API
Belongs to `gateway.networking.k8s.io/v1`

- **GatewayClass**: Defines a set of gateays w a common configuration. Managed by a controller that implements the class. It specifies a set of common properties and behaviours that any Gateway referring to it will inherit.


- **Gateway**: Defines an instance of traffic handling infrastructure.
- **HTTPRoute**: HTTP rules for mapping traffic from a Gateway listener to a representation of backend network.

```
# Gateway
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: example-gateway
spec:
  gatewayClassName: my-gateway-class
  listeners:
  - name: http
    port: 80                # the port where the gateway listens as it is the http port
    protocol: HTTP
    hostname: "www.example.com"
```



```
# HTTPRoute
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: example-httproute
spec:
  parentRefs:
  - name: example-gateway
  hostnames:
  - "www.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /login
    backendRefs:
    - name: example-svc
      port: 8080                   # targetPort of the backend service NOT the containers internal port
```

Requests sent to www.example.com with paths that start with /login will be matched by this HTTPRoute, and the traffic will be forwarded (via example-gateway) to the example-svc service on port 8080.


# LAB 2 Ingress Controller
