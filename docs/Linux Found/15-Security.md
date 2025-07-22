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

## LAB 1
The access to a cluster begins with TLS connectivity ---> then authentication and then authorization.

A K8s cluster can have multiple CA Roots, but normally each cluster manages its own CA for internal use.

In K8s there is a CA bundle that is installed on every node and added as a secret to default service accounts.


this allows secure communication between the components. Lets pods validate the identity of the API server.

Think of it like a list of "trusted signers" — if a certificate was signed by someone on this list, it’s trusted.

### Kubeadm clusters CA
- K8s creates automatically the certificates on the controlplanes under `/etc/kubernetes/pki/ca.crt`.
- It configures all the components to trust this certificate (API server, kubelet, controller manager).
- k8s default service account injects this CA in the pods or deployments and so...

## LAB 2 Authentication and Authorization
In cluster there are 2 types f users:

- Service Accounts:
Which represent workloads running inside the cluster like are Pods.
These are managed by K8s 
You can :
    - Create them w kubectl 
    - assign them permissions w RBAC
    - link them to pods for secure, scoped API access.

They come automatically w a token to authenticate to the API and a CA certificate to verify the API server.


-  Normal Users (aka Human Users)
Represent real people (e.g., DevOps engineers, developers).

Used for running kubectl, accessing the dashboard, etc.

Not managed by Kubernetes directly.

They are assumed to be managed externally, such as by:

A certificate authority (cert-based auth)

OIDC (e.g., Google, GitHub, Azure AD)

Keystone (OpenStack)

LDAP, SAML, etc.

**We will use RBACto configure access to actions within anamespacefor a new contractor,Developer Danwho will beworking on a new project.**


