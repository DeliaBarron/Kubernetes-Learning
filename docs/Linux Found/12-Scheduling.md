# Scheduling

The lower priority of pods would then allow the higher priority pod to be scheduled
The Pods specification as part of the request is sent to the kubelet on the node for creation.

Most of the scheduling decisions can be made as part of the Podspec:

- nodeName or nodeSelector: assigns pod to a particular Node or group of nodes
- taints and tolerations: allows a node to be labeld such that Pods would not be scheduled for some reason, such as the cp node after initialization. A toleration allows A pod to ignore and be scheduled assuming the other requirements are met.

## Node Label
using the `nodeSelector` all listed selectors must be met

## Pod Affinity
- `requiredDuringSchedulingIgnoredDuringExecution`: The condition must be true at the time the Pod is **scheduled.** If not, the Pod won’t be placed anywhere.
`IgnoredDuringExecution`: If the condition later becomes false, the Pod won’t be evicted. It stays running.

- `preferredDuringSchedulingIgnoredDuringExecution`softer setting

- `podAffiity`: With the use of podAffinity, the scheduler will try to schedule Pods together. This also requires a particular label to be matched when the Pod starts, but not required if the label is later removed.



# LAB
label the nodes: `k label node <node-name> status=vip`

`k get nodes --show-labels`

## taints
- `k taint node <node-name> bubba=value:NoSchedule`
- `k taint node <node-name> bubba-`
