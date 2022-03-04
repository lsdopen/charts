# LSDobserve Helm Chart

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Generic Kubernetes Cluster

Basic installation

Only run `kubectl scale sts lsdmop-logstash --replicas=1` once elastic-post-setup has finished running
```
helm show values lsdopen/lsdmop > values.yaml
helm install lsdmop lsdopen/lsdmop -n lsdmop --create-namespace --values values.yaml ; helm upgrade lsdmop lsdopen/lsdmop -n lsdmop --values values.yaml

kubectl scale sts lsdmop-logstash --replicas=1
```

Install on GKE with Admin Password and Elastic disabled
```
helm install lsdmop -n lsdmop --create-namespace \
--set lsdmop.clusterType=gke \
--set lsdmop.elastic.enabled=false \
--set grafana.adminPassword=neiliscool
```

Install on Rancher with Admin Password and SMTP details and Elastic disabled
```
helm install lsdmop -n lsdmop --create-namespace \
--set lsdmop.clusterType=rancher \
--set lsdmop.elastic.enabled=false \
--set grafana.adminPassword=neiliscool \
--set lsdmop.smtp.host=smtp.lsdopen.io \
--set lsdmop.smtp.port=25 \
--set lsdmop.smtp.fromAddress="lsdmop+noreply+api.mycluster.lsdopen.io@lsdopen.io" \
--set lsdmop.smtp.fromName="LSDobserve - LSD - api.mycluster.lsdopen.io"
```

### Restricted Network Installation

Simple installation

Only run `kubectl scale sts lsdmop-logstash --replicas=1` once elastic-post-setup has finished running
```
helm dependency update .

kubectl create ns lsdmop
helm install lsdmop . -n lsdmop --create-namespace --values values.yaml ; helm upgrade lsdmop . -n lsdmop --create-namespace --values values.yaml

kubectl scale sts lsdmop-logstash --replicas=1
```
## Test smtp details

Run this to trigger an alert to alertmanager manually:
```helm test lsdmop```

## Adding New Dashboards to Grafana

1. Place new dashboards in ./dashboards folder
2. Modify templates/grafana.dashbaords.yaml with your new dashboard details
3. Add dashboard to templates/grafana.configmap.yaml
4. Add the dashboard to the values.yaml file


## Todo
- harbor dashboards
- alertmanager dashbaord
- Dashboards in Elastic or Elastic like dashboards in Grafana
- Openshift - patch namespace to allow it to run on any nodes "oc patch namespace lsdmop -p '{"metadata":{"annotations":{"openshift.io/node-selector":""}}}'"

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
chcon -t container_file_t /var/lib/lsdmop/lsdmop-filebeat/filebeat-data
```

### Manual removal

```
k delete ns lsdmop ; k delete clusterrole lsdmop-kube-state-metrics elastic-beat-autodiscover elastic-operator elastic-operator-edit elastic-operator-view lsdmop-grafana-clusterrole lsdmop-kube-state-metrics lsdmop-prometheus-alertmanager lsdmop-prometheus-server ; k delete psp lsdmop-grafana lsdmop-grafana-test lsdmop-prometheus-blackbox-exporter-psp ; kubectl delete ClusterRoleBinding lsdmop-grafana-clusterrolebinding lsdmop-kube-state-metrics lsdmop-prometheus-alertmanager lsdmop-prometheus-server  ; k delete ClusterRoleBinding elastic-operator elastic-beat-autodiscover-binding
```
