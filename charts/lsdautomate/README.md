# LSDautomate Helm Chart

**Work In Progress**

This chart will deploy a Highly Available Postgresql cluster with Gitlab, Sonarqube, Sona-type Nexus and AWX.
They will all share the central Postgresql

For now you will need to remove `kubernetes.io/ingress.class: lsdautomate-gitlab-nginx` from all ingress points

## Quick and Dirty Install

```
helm repo add lsdopen https://lsdopen.github.io/charts
helm repo update
```

### Install on Generic Kubernetes Cluster

```
helm show values lsdopen/lsdautomate > values.yaml
helm install lsdautomate lsdopen/lsdautomate -n lsdautomate --create-namespace --values values.yaml
```

### Restricted Network Installation

Simple installation
```
helm dependency update .

kubectl create ns lsdautomate
helm install lsdautomate -n lsdautomate .
helm install lsdautomate-gitlab gitlab/gitlab -f files/gitlab.values.yaml -n lsdautomate
```

Simple uninstallation

```
helm uninstall lsdautomate -n lsdautomate 
helm uninstall lsdautomate-gitlab -n lsdautomate
kubectl delete ns lsdautomate
```

## Todo
- Get Gitlab working
- Get AWX working

## Notes

### Deployment failure

If you see the postgresql in CrashLoopBackOff and it has the following error

```
kubectl logs lsdautomate-postgresql-ha-postgresql-0 -c postgresql --tail=10

postgresql-repmgr 15:17:12.99 INFO  ==> Configuring fsync
postgresql-repmgr 15:17:13.00 INFO  ==> Stopping PostgreSQL...
postgresql-repmgr 15:17:13.00 INFO  ==> ** PostgreSQL with Replication Manager setup finished! **

postgresql-repmgr 15:17:13.02 INFO  ==> Starting PostgreSQL in background...
postgresql-repmgr 15:17:13.14 INFO  ==> ** Starting repmgrd **
[2021-02-21 15:17:13] [NOTICE] repmgrd (repmgrd 5.1.0) starting up
[2021-02-21 15:17:13] [ERROR] repmgr extension not found on this node
[2021-02-21 15:17:13] [DETAIL] repmgr extension is available but not installed in database "repmgrdatabase"
[2021-02-21 15:17:13] [HINT] check that this node is part of a repmgr cluster
```

Then reboot the nodes. This seems to happen when we try to deploy over and over again

### Database 
List Databses
```
kubectl exec postgresql-client-6877d4bffd-rkjds -it -- bash
psql -h lsdautomate-postgresql-ha-pgpool -U postgres

postgres=# \l
                                     List of databases
      Name      |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges    
----------------+----------+----------+-------------+-------------+------------------------
 gitlab         | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres          +
                |          |          |             |             | postgres=CTc/postgres +
                |          |          |             |             | gitlab=CTc/postgres
 postgres       | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 repmgrdatabase | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 sonarqube      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres          +
                |          |          |             |             | postgres=CTc/postgres +
                |          |          |             |             | sonarqube=CTc/postgres
 template0      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres           +
                |          |          |             |             | postgres=CTc/postgres
 template1      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres           +
                |          |          |             |             | postgres=CTc/postgres
(6 rows)
```

List Users
```
postgres=# \du
                                    List of roles
 Role name  |                         Attributes                         | Member of 
------------+------------------------------------------------------------+-----------
 gitlab     | Superuser                                                  | {}
 postgres   | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 repmgruser | Superuser, Replication                                     | {}
 sonarqube  |                                                            | {}
```

