# LSDContainer Helm Chart for Bastion Hosts

The purpose of this Helm chart is to deploy all the services that are typically deployed on a Bastion server for environments that have restricted services.

This is useful when you want to have all your services containerized on a bastion server

This chart will deploy the following services:

- dnsmasq (dns + dhcp + tftp)
- haproxy (load balancer)
- nginx (http server)
- okd-installer (okd ignition files)

This assumes you are running Minikube on the bastion server

## Installation and use

Disable Firewalld or allow ports for DHCP/DNS/whatever else
```
systemctl disable firewalld --now
```

Add Chart
```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

Get Values
```
helm show values lsdopen/lsdcontainer-bastion > /tmp/lsdcontainer-bastion.values.yaml
```

Modify /tmp/lsdcontainer-bastion.values.yaml with:
- correct MAC address for DHCP
- add the correct IP address for HAProxy

Deploy release
```
helm install bastion lsdopen/lsdcontainer-bastion -n lsdcontainer --create-namespace --values /tmp/lsdcontainer-bastion.values.yaml
```

## Notes

OKD installation are temperamental. This is a current working combination

```
openShiftType: "OKD"
CoreOSVersion: "32.20201104.3.0"
CoreOSMinorRelease: ""
okd:
  image:
    registry: "docker.io"
    repository: "lsdopen/okd-installer"
    tag: "latest"
  version: "4.5.0-0.okd-2020-10-15-235428"
```

## Useful URLs
Release pages:       https://github.com/openshift/okd/releases

openshift-installer: https://github.com/openshift/okd/releases/download/4.6.0-0.okd-2020-11-27-200126/openshift-install-linux-4.6.0-0.okd-2020-11-27-200126.tar.gz

openshift client:    https://github.com/openshift/okd/releases/download/4.6.0-0.okd-2020-11-27-200126/openshift-client-linux-4.6.0-0.okd-2020-11-27-200126.tar.gz

pull-secrets:        https://cloud.redhat.com/openshift/install/pull-secret
