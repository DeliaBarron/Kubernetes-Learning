# Deploying Complex Applications
## Helm
Is similar to a package manager like `apt`. The chart similar to a package, has the binaries, as well as installation and scripts.

With Helm you can package all manifests as a tarball (deployments, services, configMaps), put them on a repo and with a single command, deploy and start the entire application.

### Helm Charts
Are reusable templates thact can be shared through repositories. 
Charts can customized using `values.yaml` files. 
Convenient way to package and distribute repositories.
Helm charts are bundles of YAML Files that can be pushed to a helm repo or download this bundles from helm repositories.
 

### Chart Contents
Chart Contents
A chart is an archived set of Kubernetes resource manifests that make up a distributed application. You can learn more from the Helm 3 documentation. Others exist and can be easily created, for example by a vendor providing software. Charts are similar to the use of independent YUM repositories.

- Search for deployments or charts: `helm search <keyword>` or helmhub or helmcharts.


```
├── Chart.yaml ## contains info about the chart
├── README.md
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── pvc.yaml
│   ├── secrets.yaml
│   └── svc.yaml
└── values.yaml
```

> charts can customized using `values.yaml` files. 

If you would happen to have a cluster running different microservices, that at the time have YAML that are very alike and just some values change you could create a **Template file** where all the dynamic values can be replaced by placeholders.
This placeholders will retrieve the values from the values file we pass to them.

You can pass values and overwrite them with new ones with new values.yaml files or directly on the command line: 

In the following example you would combine both files so only version value gets overwirtten.

```
# values.yaml
 
imageName: myapp
port: 8080
version: 1.0.0
```

```
# values-file2.yaml
version: 2.0.0
```

- `helm install --values=values-file2.yaml <chartname>`

or

- `helm install --set version=2.0.0`

```
# result
imageName: myapp
port : 8080
version. 2.0.0
```

> There can be a chart folder which cointains the dependencies of your chart, if any.
### Release
Is an instance of a chart that runs in a K8s cluster. One chart can be isntalled as many times on the same cluster, for example if u want 2 DB you can install MySQl chart twice and each will have its own release.


## Helm Commands
- `helm create <app-name>`: creates the folder structure and the values.yaml files.
- `helm search hub <name>`: search for repos on the Hub 
- `helm search repo`: searches the repo that u already have in the local client(local data no internet need)
- `helm add repo <name> <repo-url>`
- `help repo list`
- `helm fetch bitnami/apache --untar`: Download tje tarball of the repo and expanding it to see contents
- `helm install <release-name> <chart-name-to-install>`
- `helm status`: keep track of the release's state.

Once u have a repository available, you can search for Charts based on keywords. 
Once u find the chart on the repo, you can deploy it on the cluster.

# LABS
- get the helm tar: `wget https://get.helm.sh/helm-v3.15.2-linux-amd64.tar.gz`

- uncompress tar: `tar -xvf helm-v3.15.2-linux-amd64.tar.gz`

- copy helm to /user/local/bin/helm: `cp linux-amd64/helm /usr/local/bin/helm`

- Search the current Charts on the Helm Hub:  `helm search hub database`

- Add repos to your instance: `helm repo add <helm-name> https://helm-chart-url/charts`

- `helm repo upgrade`

- install tester tool : `helm upgrade -i tester ealenn/echo-server  --debug` # tester is the name of the chart we give (?)

- check for the service: `kubectl get svc`


To have the service on the port 80 accesible on the port 80 with a private ip:  `k port-forward svc/tester-echo-server 8080:80`
```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```

Then you can  curl `http://localhost:8080` --> You can send a curl to this service to get more information about this.

- Chart history: `helm list`
- chart history incluiding deleted and failed attempts: `helm list -a`
- Delete a chart: `helm uninstall tester`


------------------- SUMMARY ------------------------
we installed the HELM CLI Software (NOT A HELM CHART)
we extracted it and then moved it to the helm executable

then helm commands
- helm repo list: shows the repo u have added in the system `ealenn	https://ealenn.github.io/charts`

- helm search repo : search for charts INSIDE the repos u have added in the system.

```
ealenn/echo-server	0.5.0        	0.6.0      	Echo-Server for Kubernetes            
ealenn/picolors   	0.1.0        	0.1.0      	Extract prominent colors from an image
```

Then to add the chart u can do: `helm fetch ealenn/echo-server --untar` this will downlowad a chart package and automatically extracts it.

- helm repo add <name> <url>: adds the repo so u can then use helm search and install charts from it.
- helm upgrade -i tester stable/nginx: **this would install nginx chart as tester if it doesn't exist. OR Upgrades tester if it already exist.**

- `helm install <name-u-give> <chart-to-use> [flags]` : to deploy a helm chart to the k8s cluster.
so for example once already in the directory where the values.yaml of the chart is, you can run **helm install anotherweb .**

> HS specifics: 
- `k get svc/anotherweb-apache -o yaml` : you see the port on the spec (80)

- `k port-forward svc/anotherweb-apache 1231:80`  1231 the port u assign, has to be over 1000

- then curl this port `curl http://localhost:1231`

>**A chart deployment output tells us about missing dependencies!!!!!**

 **A collection of charts is a repo**

