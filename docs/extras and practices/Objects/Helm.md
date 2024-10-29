# Introduction to Helm
Package manager for Kubernetes. Allows bringing different YAML files together in something called **Chart**.
A **Chart** groups this files together in a **template** folder and to make it **reusable** we can inject values into them as parameters.

## Values File
This file is what we inject to the Chart.

## Helm Chart
Made up with a set of YAML Files.

 It has:
- name

- Templates dir:
 All the YAML you would like to bundle up as a chart like *deployments, configmaps, secrets, services, etc...*

 - Values.yaml
 where we inject labels, values, default configurations that we can modify.

## Steps
- ` helm create <name>`
- clean templates folder.
- paste under `templates` all the yaml bundle you need.
- test if it renders correctly:
    `helm template <name of chart> <chart-folder>`

> It should deliver without error a file containing all the YAMLs files.

- Install
`helm install <name of chart>  <chart-folder>`

Helm will install all into the cluster.

- list the release:
`helm list`

- Confirm everything was deployed with corresponding **kubectl** commands:
```
kubectl get all,
kubectl get cm
kubectl get secret
```

## Value File
All the values we want to inject.
So if we want to add a deployments image and tag value:
- Go to the values.yaml and add the values for the deployment:

```
deployment:
    image: "aimvector/python"
    tag: "1.0.4"
```

- Go to the deployments file and inject the value to the key you need to modify:

```
...
    image: {{.Values.deployment.image}}:{{.Values.deployment.tag}}
...
```

- `helm upgrade <chart-name> <chart-folder> --values <path-to-values-file>`

or if you are creating a new chart with different values:

- `helm install <chart-name-to-create> --values <path-to-values-file-to-inject>`


