# LSDOPEN Charts

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

## Offline Mode / Restricted Networks

We work with many clients that prohobit internet access, so here is a workaround when you cannot access https://lsdopen.github.io/charts

```
git clone https://github.com/lsdopen/charts.git
cd charts/charts/lsdobserve/
helm dependency update .

...
Saving 6 charts
Downloading prometheus from repo https://prometheus-community.github.io/helm-charts
Downloading prometheus-blackbox-exporter from repo https://prometheus-community.github.io/helm-charts
Downloading prometheus-elasticsearch-exporter from repo https://prometheus-community.github.io/helm-charts
Downloading eck-operator-crds from repo https://helm.elastic.co
Downloading eck-operator from repo https://helm.elastic.co
Downloading grafana from repo https://grafana.github.io/helm-charts
Deleting outdated charts
...

scp -r ../lsdobserve root@my-restricted-host.com:/tmp/
ssh root@my-restricted-host.com
cd /tmp/lsdobserve/
vim values.yaml (modify your settings)
(alternative recommended, run gen.sh to modify the values.yaml file)
helm install lsdobserve -n lsdobserve --create-namespace --values run.yaml .
```
