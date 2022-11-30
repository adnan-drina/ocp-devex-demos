# 5-minute demo: Serverless (KNative Serving)
For more information, please see the [official product documentation](https://docs.openshift.com/container-platform/4.11/serverless/serverless-release-notes.html)

## Table of Contents
- **[Introduction to serverless](#introduction-to-serverless)**<br>
- **[Set up a dev environment on OpenShift](#lets-set-things-up)**<br>
- **[](#)**<br>
---

## Introduction to serverless
OpenShift Serverless .....

![serverless01](../../graphics/serverless-01.png)


## Pre-requisites

* Installed serverless operator

```shell
oc apply -f ./run/01-serverless-serving/serverless-operator-setup/01-serverless-operator-namespace.yaml
oc apply -f ./run/01-serverless-serving/serverless-operator-setup/01-serverless-operator-sub.yaml
```
**NOTE**: These components might take a few minutes to complete the install, please verify the status in "installed operators" using the web console.

* Configured knative serving

```shell
oc apply -f ./run/01-serverless-serving/knative-serving-setup/knative-serving-instance.yaml
```
**NOTE**: These components might take a few minutes to complete the install, please verify that all pods are running in the knative-serving namespace using the web console.

* Podman or docker is available to build and push containers (note this instance needs to match the target platform architecture)
* Have a publically accessible registry available, eg. quay.io
* You have the [odo](https://developers.redhat.com/content-gateway/rest/mirror/pub/openshift-v4/clients/odo/) cli installed
* You have the [kn](https://docs.openshift.com/container-platform/4.11/serverless/cli_tools/installing-kn.html) cli installed

## Creating an application

Generate a new dotnet API:

```shell
dotnet new web -o hellodotnet -n app
cd hellodotnet/
```
(note the application name needs to be app)

Generate our devfile:

```shell
odo init --devfile dotnet60 --name=hellodotnet
```

Coding with live-deploy to a cluster:

```shell
odo dev
```

Once dev is done....

## Creating a container

Add dockerfile:

```dockerfile
FROM registry.access.redhat.com/ubi8/dotnet-60:latest as builder
WORKDIR /opt/app-root/src
COPY --chown=1001 . .
RUN dotnet publish -c Release


FROM registry.access.redhat.com/ubi8/dotnet-60:latest
EXPOSE 8080
COPY --from=builder /opt/app-root/src/bin /opt/app-root/src/bin
WORKDIR /opt/app-root/src/bin/Release/net6.0/publish
CMD ["dotnet", "app.dll"]
```
## Building a container
### Option 1:
edit devfile.yaml

add variables section:

```yaml
variables:
  CONTAINER_IMAGE: quay.io/bentaljaard/dotnet-helloworld
```

add new command:

```yaml
- id: build-image
  apply:
    component: outerloop-build
```

add new component:

```yaml
- name: outerloop-build
  image:
    dockerfile:
      buildContext: ${PROJECT_SOURCE}
      rootRequired: false
      uri: ./Dockerfile
    imageName: "{{CONTAINER_IMAGE}}"
```

set schema version:

```yaml
schemaVersion: 2.2.0
```

Use odo to build the image:

```shell
odo build-images
```
```shell
podman push quay.io/bentaljaard/dotnet-helloworld
```

### Option 2:

alternatively, build with podman:

```shell
podman build -t quay.io/bentaljaard/dotnet-helloworld .
```
then push your container image to the registry:

```shell
podman push quay.io/bentaljaard/dotnet-helloworld
```

## Creating a serverless deployment

Let's prepare a new Openshift namespace to deploy our serverless function:

```shell
$ oc new-project kn-dotnet

Now using project "kn-dotnet" on server "https://api.sno-local.phybernet.org:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/e2e-test-images/agnhost:2.33 -- /agnhost serve-hostname
```

Create your serverless deployment:

```shell
$ kn service create hello --image=quay.io/bentaljaard/dotnet-helloworld:latest --port 8080    
Creating service 'hello' in namespace 'kn-dotnet':

  0.044s The Route is still working to reflect the latest desired specification.
  0.076s Configuration "hello" is waiting for a Revision to become ready.
  4.583s ...
  4.652s Ingress has not yet been reconciled.
  4.689s Waiting for load balancer to be ready
  4.939s Ready to serve.

Service 'hello' created to latest revision 'hello-00001' is available at URL:
https://hello-kn-dotnet.apps.sno-local.phybernet.org
```

Verify your deployment in the developer topology view:

![serverless02](../../graphics/serverless-02.png)

Open the URL for the service:

![serverless03](../../graphics/serverless-03.png)

Your service returns Hello World!

![serverless04](../../graphics/serverless-04.png)