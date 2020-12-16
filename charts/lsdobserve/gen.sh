#!/bin/bash

## Generator for values file
## You can still override various settings with helm --set
## Stefan Lesicnik 2020 (LSD OPEN - stefan@lsdopen.io)

# check if values.yaml exists. If not pull from chart
if test -f "values.yaml"
then
    cp values.yaml run.yaml
else
    helm show values lsdopen/lsdobserve > values.yaml
fi

#$1 = "Description"
#$2 = "Substitute VAR"
#$3 = "Default"
sub () {
    echo -n "$1 (*$3): "
    read SUB
    if [ "$SUB" == "" ]
    then
        SUB="$3"
    fi   
    sed -i .bak s+$2+$SUB+g run.yaml

    # Variables you want to keep for later substituion
    if [ "$2" == "%%DOMAIN%%" ]
    then
        DOMAIN=$SUB
    elif [ "$2" == "%%APP_DOMAIN%%" ]
    then
        APP_DOMAIN=$SUB
    fi
}

sub "Cluster type (gke | rancher | openshift)" "%%CLUSTER_TYPE%%" "openshift"
sub "Domain (typically domain suffix" "%%DOMAIN%%" "lsdopen.io"
sub "App domain (typically ingress route" "%%APP_DOMAIN%%" "apps.$DOMAIN"
sub "SMTP (smtp.$DOMAIN)" "%%SMTP%%" "smtp.$DOMAIN"
sub "SMTP Port" "%%SMTP_PORT%%" "25"
sub "Storage Class" "%%STORAGE_CLASS%%" "standard"
sub "Client Name" "%%CLIENT%%" "None"
