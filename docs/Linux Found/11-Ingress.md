# Ingress
Just as we use Service to expose a containerized app outside the cluster, we use **Ingress Controllers and Rules** but Ingress is way mor efficient as we can route traffic based on the reques host or path. this allows the centralization of many services to a single point.

Ingress Controllers (such as Traeffik), use rules to handle the traffic to and from the cluster. Rules are created with `kubectl`