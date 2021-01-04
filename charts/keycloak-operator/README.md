# Keycloak Operator

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Generic Kubernetes Cluster

```
helm install lsdobserve lsdopen/keycloak-operator -n lsdobserve --create-namespace
```
