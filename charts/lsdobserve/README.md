# LSD-Observe Helm Chart

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

Install on GKE with Admin Password set
```
helm install lsd-observe -n lsd-observe --create-namespace  --set grafana.adminPassword=neiliscool --set lsdobserve.clusterType=gke

helm install lsd-observe -n lsd-observe --create-namespace --set grafana.adminPassword=neiliscool
```

Install on GKE with Admin Password and Elastic disabled
```
helm install lsd-observe -n lsd-observe --create-namespace \
--set lsdobserve.clusterType=gke \
--set lsdobserve.elastic.enabled=false \
--set grafana.adminPassword=neiliscool
```

Install on Rancher with Admin Password and SMTP details and Elastic disabled
```
helm install lsd-observe -n lsd-observe --create-namespace \
--set lsdobserve.clusterType=rancher \
--set lsdobserve.elastic.enabled=false \
--set grafana.adminPassword=neiliscool \
--set lsdobserve.smtp.host=smtp.lsdopen.io \
--set lsdobserve.smtp.port=25 \
--set lsdobserve.smtp.fromAddress="lsdobserve+noreply+api.mycluster.lsdopen.io@lsdopen.io" \
--set lsdobserve.smtp.fromName="LSD-Observe - LSD - api.mycluster.lsdopen.io"
```

## Adding New Dashboards to Grafana

1. Place new dashboards in ./dashboards folder
2. Modify templates/dashboards.configmap.yaml with your new dashboard details


## Todo
- SMTP
- curation for elastic
- alerts for alertmanager
- alertmanager dashbaord
- Keycloak
- Dashboards in Elastic or Elastic like dashboards in Grafana
