# kubectl
> Get general info from the pods @ your cluster as well as their age and status

- `kubcetl get pods`


kubectl get nodes
kubectl describe node <node-name>

To get the name of the cluster at the monitoring (prometheus) you can run:

- `kubectl get ingress -n monitoring`

Get all namespaces from the actual context:

- `kubectl get namespaces`

Create a namespace:
- `kubectl create namespace <ns-name>`

Delete a namespace:
- `kubectl delete namespace <ns-name>`

Apply or create a k8s resource:

- `kubectl apply -f nginx-pod.yaml`
- `kubectl get pods`
- `kubectl get pod nginx-pod -o yaml`
- `kubectl describe pod nginx-pod`
- `kubectl delete pod nginx-pod`

