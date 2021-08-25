# LSDcontainer Helm Chart

## Installation

First install the minIO operator

```
helm repo add minio https://operator.min.io/
helm install minio-operator --namespace minio-operator --create-namespace minio/minio-operator --values minio-values.yaml
```

Edit your values file
```
vim values.yaml
```

Then deploy the Chart
```
helm install lsdcontainer . -n lsdcontainer --create-namespace --values values.yaml
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm install velero --namespace lsdcontainer vmware-tanzu/velero --values velero-values.yaml
```

Verify minIO tenant is operational
```
kubectl -n lsdcontainer get tenant 
```

## Offline / Restrcited Installation

Simple installation
```
helm dependency update .
helm install lsdcontainer . -n lsdcontainer --create-namespace --values values.yaml
```

## Uninstall 

```
helm uninstall minio-operator -n minio-operator
kubectl delete ns minio-operator
kubectl delete crd tenants.minio.min.io
```

## Notes

Stuff we want here:
- MinIO - Cloud Object Storage
- Velero - Project / Namespace backups
- ETCD backups for Openshift & Rancher
- Maybe move LSDobserve to LSDmonitoring here
- ArgoCD or lightweight GitOps to enforce cluster changes
- Gitlab or lightweight git repo thing
- OS level Patching for Nodes

### Helpful Articles

https://github.com/vmware-tanzu/velero/blob/main/site/content/docs/v1.5/contributions/minio.md
