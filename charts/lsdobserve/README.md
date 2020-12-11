# LSDobserve Helm Chart

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Rancher

```
helm upgrade lsdobserve lsdopen/lsdobserve -n lsdobserve --create-namespace --values values.yaml
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

## Adding New Dashboards to Grafana

1. Place new dashboards in ./dashboards folder
2. Modify templates/grafana.dashbaords.yaml with your new dashboard details
3. Add dashboard to templates/grafana.configmap.yaml
4. Add the dashboard to the values.yaml file


## Todo
- SMTP
- curation for elastic
- metadata on filebeat
- ceph dashboards
- harbor dashboards
- alerts for alertmanager
- alertmanager dashbaord
- Keycloak
- Dashboards in Elastic or Elastic like dashboards in Grafana
