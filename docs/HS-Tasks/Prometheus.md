# Prometheus
## Service Discovery
Prometheus automatically finds Kubernetes resources (Pods, Nodes, Services) to monitor, using Kubernetes APIs. This means there is no need to manually tell Prometheis about new or removed components.

## Exporters
Enpoints exposing metrics in a Prometheus format.

- **Node Exporter**: Provides hardware and OS-Level metrics

- **kube-state-metrics**: Exposes metrics about resources (Deployments, Pods, etc)

- **Application-specific Exporters**: For databases, web servers, etc. (e.g., MySQL exporter, Redis exporter).

## Prometheus Server
It uses a configuration file to define what to scrape and where to send alerts.

## Alertmanager
- Separate component from Prometheus.
- Used to route alerts to notification channels ( Slack, email, PagerDuty).


## Rules  VS Service  Discovery
- **Service Discovery** finds and identifies **what to monitor**.
- **Rules** define **What to do** with the data prometheus has already collected.

## Recoding Rules VS Alerting Rules
In Prometheus there are 2 types of rules: recording and alerting, which in practice are often used together:

**Recording Rules**: Precompute and store queries for efficient reuse.

**Alerting Rules**: They use the precomputed metric in a simpler alerting rule to trigger notifications.


## HS Specifics
We have 10 k8s clusters, each of which has its own set of rules.

## Rules Group
### alertmanager.rules

 **AlertmanagerFailedReload:**
  - *Reloading an Alertmanager configuration has failed.*

**AlertmanagerMembersInconsistent**
  - *A member of an Alertmanager cluster has not found all other cluster members*

**AlertmanagerFailedToSendAlerts**
- An Alertmanager instance failed to send notifications.

**AlertmanagerClusterFailedToSendAlerts**
- All Alertmanager instances in a cluster failed to send notifications to a critical integration

**AlertmanagerConfigInconsistent**
- Alertmanager instances within the same cluster have different configurations.

**AlertmanagerCLusterDown**
-  Half or more of the Alertmanager instances within the same cluster are down.

**AlertmanagerClusterCrashlooping**
- Half or more of the Alertmanager instances within the same cluster are crashlooping.


 ### config-reloaders

**ConfigReloadersSidecarErrors**
- config-reloader sidecar has not had a successful reload for 10m.

### etcd

**etcdMembersDown**
- etcd cluster members are down.

**etcdInsufficientMembers**
- etcd cluster has insufficient number of members.

**etcdNoLeader**
- etcd cluster has no leader.

**etcdHighNumberOfLeaderChanges**
- etcd cluster has high number of leader changes.

**etcdHighNumberOfFailedGRPCRequest (1 and 5)**
- etcd cluster has high number of failed grpc requests.

**etcdGTPCRequestsSlow**
- etcd grpc requests are slow

**etcdMemberCommunicationSlow**
- etcd cluster member communication is slow.

**etcdHighNumberOfFailedProposals**
- etcd cluster has high number of proposal failures.

**etcdHighFsyncDurations**
- etcd cluster 99th percentile fsync durations are too high.

**etcdHighFsyncDurations**
- etcd cluster 99th percentile fsync durations are too high.

**etcdHighCommitDurations**
- etcd cluster 99th percentile commit durations are too high.

**etcdDatabaseQuotaLowSpace**
- etcd cluster database is running full.

**etcdExcessiveDatabaseGrowth**
- etcd cluster database growing very fast.

**etcdDatabaseHighFragmentationRatio**
- etcd database size in use is less than 50% of the actual allocated storage.

### general.rules
**TargetDown**
- One or more targets are unreachable.

**Watchdog**
- An alert that should always be firing to certify that Alertmanager is working properly.

**InfoInhibitor**
- Info-level alert inhibition.

### kube-apiserver-slos
**KubeAPIErrorBudgetBurn** (for 1 and 6hrs)
- The API server is burning too much error budget.

### kube-state-metrics
**KubeStateMetricsListErrors**
- kube-state-metrics is experiencing errors in **list** operations.

**KubeStateMetricsWatchErrors**
- kube-state-metrics is experiencing errors in **watch** operations.

**KubeStateMetricsShardingMismatch**
- kube-state-metrics sharding is misconfigured.

**KubeStateMetricsShardsMissing**
- kube-state-metrics shards are missing.

### kubernetes-apps
**KubePodCrashLooping**
-  Pod is crash looping

**KubePodNotReady**
- Pod has been in a non-ready state for more than 15 minutes.

**KubeDeploymentGenerationMismatch**
- Deployment generation mismatch due to possible roll-back

**KubeDeploymentReplicasMismatch**
- Deployment has not matched the expected number of replicas.

**KubeStatefulSetReplicasMismatch**
- Deployment has not matched the expected number of replicas.

**KubeStatefulSetGenerationMismatch**
- StatefulSet generation mismatch due to possible roll-back.

**KubeStatefulSetUpdateNotRolledOut**
- StatefulSet update has not been rolled out.

**KubeDaemonSetRolloutStuck**
- DaemonSet rollout is stuck.

**KubeContainerWaiting**
- Pod container waiting longer than 1 hour.

**KubeDaemonSetNotScheduled**
- DaemonSet pods are not scheduled.

**KubeDaemonSetMisScheduled**
- DaemonSet pods are misscheduled.

**KubeJobNotCompleted**
- Job did not complete in time

**KubeJobFailed**
-  Job failed to complete.

**KubeHpaReplicasMismatch**
- HPA has not matched desired number of replicas.

**KubeHpaMaxedOut**
- HPA is running at max replicas

### kubernetes-resources

**KubeCPUOvercommit**
- Cluster has overcommitted CPU resource requests.

**KubeMemoryOvercommit**
- Cluster has overcommitted memory resource requests.

**KubeCPUQuotaOvercommit**
-  Cluster has overcommitted CPU resource requests.

**KubeMemoryQuotaOvercommit**
-  Cluster has overcommitted memory resource requests.

**KubeQuotaAlmostFull**
- Namespace quota is going to be full.

**KubeQuotaFullyUsed**
- Namespace quota is fully used.

**KubeQuotaExceeded**
- Namespace quota has exceeded the limits.

**CPUThrottlingHigh**
 - Processes experience elevated CPU throttling.

### kubernetes-storage
**KubePersistentVolumeFillingUp**
- PersistentVolume is filling up.

**KubePersistentVolumeInodesFillingUp**
-  PersistentVolumeInodes are filling up.

**KubePersistentVolumeErrors**
- PersistentVolume is having issues with provisioning.

### kubernetes-system
**KubeVersionMismatch**
- Different semantic versions of Kubernetes components running.

**KubeClientErrors**
- Kubernetes API server client is experiencing errors.

### kubernetes-system-apiserver
**KubeClientCertificateExpiration**
- Client certificate is about to expire.

**KubeAggregatedAPIErrors**
- Kubernetes aggregated API has reported errors.

**KubeAggregatedAPIDown**
- Kubernetes aggregated API is down.

**KubeAPIDown**
- Target disappeared from Prometheus target discovery.

**KubeAPITerminatedRequests**
- The kubernetes apiserver has terminated $value of its incoming requests.

### kubernetes-system-controller-manager
**KubeControllerManagerDown**
- Target disappeared from Prometheus target discovery.

### kubernetes-system-kube-proxy

**KubeProxyDown**
- Target disappeared from Prometheus target discovery.

### kubernetes-system-kubelet
**KubeNodeNotReady**
- Node is not ready.

**KubeNodeUnreachable**
- Node is unreachable.

**KubeletTooManyPods**
- Kubelet is running at capacity.

**KubeNodeReadinessFlapping**
- Node readiness status is flapping.

**KubeletPlegDurationHigh**
-  Kubelet Pod Lifecycle Event Generator is taking too long to relist.

**KubeletPodStartUpLatencyHigh**
- Kubelet Pod startup latency is too high.

**KubeletClientCertificateExpiration**
- Kubelet **client** certificate is about to expire.

**KubeletServerCertificateExpiration**
- Kubelet **server** certificate is about to expire.

**KubeletClientCertificateRenewalErrors**
- Kubelet has failed to renew its client certificate.

**KubeletServerCertificateRenewalErrors**
- Kubelet has failed to renew its server certificate.

**KubeletDown**
- Target disappeared from Prometheus target discovery.

### kubernetes-system-scheduler

**KubeSchedulerDown**
- Target disappeared from Prometheus target discovery.

### node-exporter
**NodeFilesystemSpaceFillingUp**
- Filesystem is predicted to run out of space within the next 24 hours.

**NodeFilesystemAlmostOutOfSpace**
- Filesystem has less than 5% & 3% space left.

**NodeFilesystemFilesFillingUp**
- Filesystem is predicted to run out of inodes within the next 4 and 24 hours.

**NodeFilesystemAlmostOutOfFiles**
- Filesystem has less than 5% & 3% inodes left.

**NodeNetworkReceiveErrs**
- Network interface is reporting many receive errors.

**NodeNetworkTransmitErrs**
- Network interface is reporting many transmit errors.

**NodeHighNumberConntrackEntriesUsed**
- Number of conntrack are getting close to the limit.

**NodeTextFileCollectorScrapeError**
- Node Exporter text file collector failed to scrape.

**NodeClockSkewDetected**
- Clock skew detected.

**NodeClockNotSynchronising**
- Clock not synchronising.

**NodeRAIDDegraded**
- RAID Array is degraded

**NodeRAIDDiskFailure**
- Failed device in RAID array

**NodeFileDescriptorLimit**
- Kernel is predicted to exhaust file descriptors limit soon.

### node-exporter.rules

### node-network
**NodeNetworkInterfaceFlapping**
- Network interface is often changing its status

### prometheus
**PrometheusBadConfig**
- Failed Prometheus configuration reload.

**PrometheusNotificationQueueRunningFull**
- Prometheus alert notification queue predicted to run full in less than 30m.

**PrometheusErrorSendingAlertsToSomeAlertmanagers**
- Prometheus has encountered more than 1% errors sending alerts to a specific Alertmanager.

**PrometheusNotConnectedToAlertmanagers**
- Prometheus is not connected to any Alertmanagers.

**PrometheusTSDBReloadsFailing**
- Prometheus has issues reloading blocks from disk.

**PrometheusTSDBCompactionsFailing**
- Prometheus has issues compacting blocks.

**PrometheusNotIngestingSamples**
- Prometheus is not ingesting samples.

**PrometheusDuplicateTimestamps**
- Prometheus drops samples with out-of-order timestamps.

**PrometheusOutOfOrderTimestamps**
- Prometheus drops samples with out-of-order timestamps.

**PrometheusRemoteStorageFailures**
- Prometheus fails to send samples to remote storage.

**PrometheusRemoteWriteBehind**
- Prometheus remote write is behind.

**PrometheusRemoteWriteDesiredShards**
- Prometheus remote write desired shards calculation wants to run more than configured max shards.

**PrometheusRuleFailures**
- Prometheus is failing rule evaluations.

**PrometheusMissingRuleEvaluations**
- Prometheus is missing rule evaluations due to slow rule group evaluation.

**PrometheusTargetLimitHit**
- Prometheus has dropped targets because some scrape configs have exceeded the targets limit.

**PrometheusLabelLimitHit**
- Prometheus has dropped targets because some scrape configs have exceeded the labels limit.

**PrometheusScrapeBodySizeLimitHit**
-  Prometheus has dropped some targets that exceeded body size limit.

**PrometheusScrapeSampleLimitHit**
- Prometheus has failed scrapes that have exceeded the configured sample limit.

**PrometheusTargetSyncFailure**
- Prometheus has failed to sync targets.

**PrometheusHighQueryLoad**
- Prometheus is reaching its maximum capacity serving concurrent requests.

**PrometheusErrorSendingAlertsToAnyAlertmanager**
-  Prometheus encounters more than 3% errors sending alerts to any Alertmanager.

### prometheus-operator
**PrometheusOperatorListErrors**
-  Errors while performing list operations in controller.

**PrometheusOperatorWatchErrors**
- Errors while performing watch operations in controller.

**PrometheusOperatorSyncFailed**
- Last controller reconciliation failed

**PrometheusOperatorReconcileErrors**
- Errors while reconciling controller.

**PrometheusOperatorNodeLookupErrors**
- Errors while reconciling Prometheus.

**PrometheusOperatorNotReady**
- Prometheus operator not ready

**PrometheusOperatorRejectedResources**
- Resources rejected by Prometheus operator

### x509-certificate-exporter.rules

**X509ExporterReadErrors**
- Increasing read errors for x509-certificate-exporter

**CertificateError**
- Certificate cannot be decoded

**CertificateRenewal**
- Certificate should be renewed

**CertificateExpiration**
- Certificate is about to expire

### velero
**VeleroBackupPartialFailures**
- Velero backup has partialy failed backups.

**VeleroBackupFailures**
- Velero backup has failed backups.