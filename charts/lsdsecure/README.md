# LSDsecure Helm Chart

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Generic Kubernetes Cluster

```
helm show values lsdopen/lsdsecure > lsdsecure.values.yaml
helm install lsdsecure lsdopen/lsdsecure -n lsdsecure --create-namespace --values lsdsecure.values.yaml
```
