# LSDContainer Helm Chart for Bastion Hosts

The purpose of this Helm chart is to deploy all the services that are typically deployed on a Bastion server for environments that have restricted services.

This chart will deploy the following services:

- dhcp-server (dynamic IP addresses)
- bind (DNS)
- tftp-server (PXE)
- haproxy (load balancer)

## Installation and use

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
