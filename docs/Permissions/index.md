# Role Based Access Control - Permissions
### General Rules
Each cluster is different but some general rules can apply:

- namespace level (RoleBindings NOT ClusterRoleBindings)
- avoid wildcard permissions as K8s is an extensible system


## Drinton
 we use kx and kns

 in my local pc i need .kube

 each cluster has a client id
 - we hacve to specify with "context" what cluster we want to access

We have roles and cluster roles

RoleBIndings: gets an user, uses the id of the user (client id) and binds the user to the permissions (role).



Every namespace has its own repo
but not for the default namespaces.

## Namespace
namespaces is just an object in k8s is not that is contained somewhere and we need an ip to acces it or thta is isolated or something like that. Is a way of defining a resource in K8s.


## steps documetation mas o menos
- he added permissions, verify namespace in the rbac fie, kind rolebinding and clster role for those permissions that are at cluster role (investigate where is rolebinding used? like at what level/scope and the type of info)

check the files under rbac

- then apply the files
- then clean the user cache
- then impersonate users to test
- and when everything is working, he will push the changes of the files to the cloudwifi repo


