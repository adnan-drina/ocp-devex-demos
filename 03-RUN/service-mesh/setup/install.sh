oc apply -k https://github.com/redhat-cop/gitops-catalog/elasticsearch-operator/overlays/stable
oc apply -k https://github.com/redhat-cop/gitops-catalog/jaeger-operator/overlays/stable
oc apply -k https://github.com/redhat-cop/gitops-catalog/kiali-operator/overlays/stable
sleep 90
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/operator/overlays/stable
sleep 120
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/instance/overlays/default