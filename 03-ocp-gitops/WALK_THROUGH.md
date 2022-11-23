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