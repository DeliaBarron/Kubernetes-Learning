# TASK 1
`kubectl config` commands necessary for change of context and users

K8s kubectl checks for the file $HOME/.kube/config
If we are using another path we can specify it with `--kubeconfig` then the path and then all the subcommands we normally would use

k --kubeconfig /file/path config get-context -o name

How to decode the certificate Base64
`echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1...........RS0tLS0tCg== | base64 -d > base.file`
Question 2 | MinIO Operator, CRD Config, Helm Install
 
# Task 2
Operators



# Task 3
- to see ehat controller is managing this pod you can get all controllers and grep the name base of the pod
`k -n namespace get deploy,ds,sts | grep pod-name`

then u get the controller name and scale it down:
`k -n namespace scale sts sts-name --replicas=1`

Use label selectors too — for example:
`kubectl -n <namespace> get all -l app=nginx`

If a Pod has a label like app=nginx, and so does a Deployment or StatefulSet, it’s a good sign they’re related.

# Task 4


