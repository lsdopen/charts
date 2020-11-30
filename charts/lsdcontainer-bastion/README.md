# LSDContainer Helm Chart for Bastion Hosts

The purpose of this Helm chart is to deploy all the services that are typically deployed on a Bastion server for environments that have restricted services.

This chart will deploy the following services:

- dnsmasq (dns + dhcp + tftp)
- haproxy (load balancer)

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

Deploy release
```
helm install bastion lsdopen/lsdcontainer-bastion -n lsdcontainer --create-namespace --values /tmp/lsdcontainer-bastion.values.yaml
```
