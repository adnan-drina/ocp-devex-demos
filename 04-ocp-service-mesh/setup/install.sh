oc apply -k https://github.com/redhat-cop/gitops-catalog/elasticsearch-operator/overlays/stable

oc apply -k https://github.com/redhat-cop/gitops-catalog/jaeger-operator/overlays/stable

oc apply -k https://github.com/redhat-cop/gitops-catalog/kiali-operator/overlays/stable

sleep

oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/operator/overlays/stable

sleep

oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/instance/overlays/default

sleep

#code repo
#https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m3-labs.git
#cd ./demo && git checkout ocp-4.10