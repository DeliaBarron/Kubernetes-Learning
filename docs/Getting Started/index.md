# Installation
In Kubernetes you can install services with either `kubectl apply` or through Helm

## Kubectl apply
You can apply configurations (YAML or JSON files) to define a k8s resource.
This is simpler for smaller-scalle deployments, it requires to manually manage YAML files and re-apply for changes.

**Use kubectl when you have simpler applications with fewer resources**


## Helm charts
Similar to `apt`, `helm` is a package manager for k8s.
Helm uses charts (**packages of pre-configured k8s resources**) to package all the resources needed for an application to run.
The file `values.yaml`can be used to override default settings making it easier to customize deployments for different environments.

**Use helm when you want to take advantage of versioned packages**
**Another** description of Helm Charts would be that is the ***bundle*** of YAML configuration files.
Using Helm you could create your own helm charts and push them to helm repositories or download existing ones.
*Just as in APT*

### Helm Templating
You can define a common bluprint for all the microservices at the k8s cluster and the dynamic values are replaced by **placeholders**

So, in your YAML template you would have your configurations with a specific synthax:
`{{.Values.container.name}}`

This '.values' synthax comes from an external configuration YAML file named `values.yaml` where all the values that are gonna be used in the template, are defined.
Valuess can also be define through CLI with `--set` flag so you can set this values dynamically.

So, when creating your own Helm Chart you can reuse this to deploy in your different K8s clusters (deployment,production or staging)

#### Values Injection into a Template file




----------------
