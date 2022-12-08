#!/bin/bash

DELAY=$1

echo Deploy Catalog service........

oc project catalog #|| oc new-project catalog
oc delete -n catalog dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

mvn clean install spring-boot:repackage -DskipTests -f ./demo/catalog

oc new-app --as-deployment-config -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:10-el8 \
             --name=catalog-database

oc new-build registry.access.redhat.com/ubi8/openjdk-11 --binary --name=catalog-springboot -l app=catalog-springboot

if [ ! -z $DELAY ]
  then
    echo Delay is $DELAY
    sleep $DELAY
fi

oc start-build catalog-springboot --from-file ./demo/catalog/target/catalog-1.0.0-SNAPSHOT.jar --follow
oc new-app catalog-springboot --as-deployment-config -e JAVA_OPTS_APPEND='-Dspring.profiles.active=openshift'

oc label dc/catalog-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/catalog-springboot app.openshift.io/runtime=spring --overwrite && \
oc label dc/catalog-springboot app.kubernetes.io/part-of=catalog --overwrite && \
oc label dc/catalog-database app.kubernetes.io/part-of=catalog --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/connects-to=catalog-database --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-ref=ocp-4.10 --overwrite
