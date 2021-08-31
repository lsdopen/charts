# LSDobserve Helm Chart

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Generic Kubernetes Cluster

Basic installation

Only run `kubectl scale sts lsdobserve-logstash --replicas=1` once elastic-post-setup has finished running
```
helm show values lsdopen/lsdobserve > values.yaml
helm install lsdobserve lsdopen/lsdobserve -n lsdobserve --create-namespace --values values.yaml ; helm upgrade lsdobserve lsdopen/lsdobserve -n lsdobserve --values values.yaml

kubectl scale sts lsdobserve-logstash --replicas=1
```

Install on GKE with Admin Password and Elastic disabled
```
helm install lsdobserve -n lsdobserve --create-namespace \
--set lsdobserve.clusterType=gke \
--set lsdobserve.elastic.enabled=false \
--set grafana.adminPassword=neiliscool
```

Install on Rancher with Admin Password and SMTP details and Elastic disabled
```
helm install lsdobserve -n lsdobserve --create-namespace \
--set lsdobserve.clusterType=rancher \
--set lsdobserve.elastic.enabled=false \
--set grafana.adminPassword=neiliscool \
--set lsdobserve.smtp.host=smtp.lsdopen.io \
--set lsdobserve.smtp.port=25 \
--set lsdobserve.smtp.fromAddress="lsdobserve+noreply+api.mycluster.lsdopen.io@lsdopen.io" \
--set lsdobserve.smtp.fromName="LSDobserve - LSD - api.mycluster.lsdopen.io"
```

### Restricted Network Installation

Simple installation

Only run `kubectl scale sts lsdobserve-logstash --replicas=1` once elastic-post-setup has finished running
```
helm dependency update .

kubectl create ns lsdobserve
helm install lsdobserve . -n lsdobserve --create-namespace --values values.yaml ; helm upgrade lsdobserve . -n lsdobserve --create-namespace --values values.yaml

kubectl scale sts lsdobserve-logstash --replicas=1
```


## Adding New Dashboards to Grafana

1. Place new dashboards in ./dashboards folder
2. Modify templates/grafana.dashbaords.yaml with your new dashboard details
3. Add dashboard to templates/grafana.configmap.yaml
4. Add the dashboard to the values.yaml file


## Todo
- harbor dashboards
- alertmanager dashbaord
- Dashboards in Elastic or Elastic like dashboards in Grafana
- Openshift - patch namespace to allow it to run on any nodes "oc patch namespace lsdobserve -p '{"metadata":{"annotations":{"openshift.io/node-selector":""}}}'"

## Notes

If you get the following error on Filebeat
```
2021-03-03T12:05:09.464Z	INFO	instance/beat.go:645	Home path: [/usr/share/filebeat] Config path: [/usr/share/filebeat] Data path: [/usr/share/filebeat/data] Logs path: [/usr/share/filebeat/logs]
2021-03-03T12:05:09.464Z	INFO	instance/beat.go:373	filebeat stopped.
2021-03-03T12:05:09.464Z	ERROR	instance/beat.go:956	Exiting: Failed to create Beat meta file: open /usr/share/filebeat/data/meta.json.new: permission denied
Exiting: Failed to create Beat meta file: open /usr/share/filebeat/data/meta.json.new: permission denied
```

Then you have an SELinux issue, and can resolve it with the following command, that needs to be run on all servers
```
chcon -t container_file_t /var/lib/lsdobserve/lsdobserve-filebeat/filebeat-data
```

### Manual removal

```
k delete ns lsdobserve ; k delete clusterrole lsdobserve-kube-state-metrics elastic-beat-autodiscover elastic-operator elastic-operator-edit elastic-operator-view lsdobserve-grafana-clusterrole lsdobserve-kube-state-metrics lsdobserve-prometheus-alertmanager lsdobserve-prometheus-server ; k delete psp lsdobserve-grafana lsdobserve-grafana-test lsdobserve-prometheus-blackbox-exporter-psp ; kubectl delete ClusterRoleBinding lsdobserve-grafana-clusterrolebinding lsdobserve-kube-state-metrics lsdobserve-prometheus-alertmanager lsdobserve-prometheus-server  ; k delete ClusterRoleBinding elastic-operator elastic-beat-autodiscover-binding
```
