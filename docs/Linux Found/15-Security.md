# Security
To access K8s Clusters you need:
- Authentication (token)
- Authorization (RBAC)
- Admission Controllers

## RBAC
- determine or create namespace
- create certificate credentials for user
- set the credentials for the user to the namespace using context
- Create a role for the expected task set
- Bind the user to the role
- Verify the user has limited access

## Network Policy
control traffic at OSI layers 3 and 4 (IPs and Ports) so they are useful for Pod-to-Pod and Pod to External trafic based on ip, port, protocol.

the **spec** of the polixy can narrow down the effect to a particular namespace. further settings include a **podSelector**  to narrow down which Pods are affected