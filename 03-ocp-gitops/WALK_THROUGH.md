# Argo CD - Declarative GitOps CD for Kubernetes

---
Application definitions, configurations, and environments should be declarative and version controlled. Application deployment and lifecycle management should be automated, auditable, and easy to understand.

---

### Installing the OpenShift GitOps (Argo CD) operator
For a quick install we'll use [Red Hat COP GitOps Catalog](https://github.com/redhat-cop/gitops-catalog/tree/main/openshift-gitops-operator)

```shell
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-gitops-operator/overlays/latest
```

```shell
oc get -n openshift-gitops route openshift-gitops-server -o jsonpath="{.spec.host}"
```

```shell
oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app \
&& oc expose svc/dotnet-demo
```

```shell
oc get all -l app=dotnet-demo -o yaml > ./dotnet-demo.yaml
```

oc new-project dotnet-demo-dev
oc label namespace dotnet-demo-dev argocd.argoproj.io/managed-by=openshift-gitops