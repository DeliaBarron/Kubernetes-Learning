# Troubleshooting / Tickets
You will find some context information and then the work around if provided.

## Sealed Secrets / Secrets in K8s

Sealed secrets is a k8s controller and CLI that encrypts so **it can only be decrypted by the controller which has the private key**.

### Secrets in K8s
Secrets are tje resource that manages the deployment of sensitive information.

<span style="color:mediumslateblue";s>Secrets can be mounted as data volumes or exposed as environment variables to the containers in a K8s Pod.</span>

The data stored is encoded using Base64, so from a **Secret** like this:
```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: d2VsY29tZSB0bw==
  password: Zm94dXRlY2g=
```

you can easily decode with:

` echo -n Zm94dXRlY2g= | base64 -d`

Because of this you should then:

- Enable encryption at rest
- Enable RBAC rules to access secrets in a cluster
- Restrict Secrets to specific containers
- Consider using external Secret store providers

## Sealed Secrets
Sealed Secrets can be decrypted **ONLY** by the controller running in the target cluster.
You will also need `kubeseal` which retrieves the public key for encryption purposes.

> The private key is only available to the Sealed Secrets controller on the cluster, and the public key is available to the developers. This way, only the cluster can decrypt the secrets, and the developers can only encrypt them.