# Troubleshooting / Tickets
You will find some context information and then the work around if provided.

## Secrets in K8s

Sealed secrets is a k8s controller and CLI that encrypts so **it can only be decrypted by the controller which has the private key**.

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

### CMS Deployments
As soon as they have a new customer, we need to create their users in MinIO, buckets and their `strap-instance`.

- At their cluster cloudwifi-prod thei have a namespace called `cloudwifi-cms` that they use for CMS to manage the pics and files for the login pages they provide.

- Confluence: they use it for documentation.
they push their secrets on gitlab, so they do sealed secrets.

- when you create a sealed secret you specify the namespace of the sealed secrets controller that will ve able to dencrypt.

- to create the sealed we gave the command the values we want to encrypt with the key included. and creates the file of the sealed-secrets. when running the command to create the sealedsecrets make sure you generate passwords or values or if the customer needs specific values, to run the command with the correct values depending on the ticket info.
(In this case, Frederix provided the userPassword values.)

>One strapi-instance, is one customer and its own Minio or bucket. Each bucket has a policy.
>One strapi-instance, is one customer and its own Minio or bucket. Each bucket has a policy.
>Minio create  bucket steps are in confluence documentation.

In order to create the bucket (in summary) you need to get the secrets and then inside their MinIO instance, then create a bucket in the MinIO UI. The password for the Frederix user is in their documentation too.

- We copied a last strapi-instance file and then do the corresponding changes like the `strapi-id` in the whole file (the customer ID is the strapi-id)

-once the buckets are created with this user and password values for each customer/ strapi id we create the DB on postgress (documentation id confluence too) *see postgres documentation for this*

- when running the postgress command ensure the db were created (thay have the srtrapi name on the table) and then to apply this files we need to create a merge request to their repository.

- -MR: we create a new branch, "new-strapi-instannces", den push to this new branch with the commint message of the strapi-ID of the instances.

- Go to thier argoCD gitlab to verify the push of the new files.

## Geo mobile DB cluster
*for postgres db*

they have High Availability in the prod and staging
but the issue is that in staging we have 2 primary pods for db instead of only one primary and 2 slaves. THis is due a bug in postgres we still dont have this clear

documentation to see the sstatus of the DB replica status: `https://gitlab.admin.hundertserver.com/kubernetes/geo.fra1/-/tree/main/postgis-staging?ref_type=heads#get-repmgr-status`

After checking the status on the 3 pods you can see in which pod relies the error, as one of this will double the information of which one is the percieved as the primary one.

### solution
restart / delete the pod

## Upgrade vault
in Vault we have
we actually didnt have resources


so he scale down the (scale --replicas 0 ) pods we are not using (0/2 for example) and doing this we get more resources free to upgrade vault in the worker nodes

`kubectl exec vault-0 -- vault operator raft list-peers`
we execute this inside the vault-0 pod and see the 3 pods/ containers runing vault in this 3 -piece cluster.
you would have to run this list peers command for all 3 vault pods to ensure the information is being seen the same on all the pods.


### Difference between delete and scale down
- **scale down pods:** changes the deployment info to the number of replicas u specify with `--replicas` flag.
- **delete pod:** as soon as you delete a pod a pod gets terminated k8s will terminate the pod but at the same time recreate it cause the replicaset has 1 pod set so it has to have a pod created.