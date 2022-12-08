- Login to OpenShift
oc login -u 

- Create a new project on OpenShift
oc new-project development

- login to Azure DevOps and run all build and all deploy pipelines
https://dev.azure.com/adnandrina/eshop-demo

- deploy Service Mesh
# install prereq
oc apply -k https://github.com/redhat-cop/gitops-catalog/elasticsearch-operator/overlays/stable &&\
oc apply -k https://github.com/redhat-cop/gitops-catalog/jaeger-operator/overlays/stable &&\
oc apply -k https://github.com/redhat-cop/gitops-catalog/kiali-operator/overlays/stable
# install operator
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/operator/overlays/stable
# create an instance
oc apply -k https://github.com/redhat-cop/gitops-catalog/openshift-servicemesh/instance/overlays/default
# add project to the mesh
oc apply -f - << EOF
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: istio-system
spec:
  members:
    - development
EOF

# patch infra components
oc patch dc/mongo --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/mssql-server --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/rabbitmq --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/redis --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/seq --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]'
# patch app components
oc patch dc/basketapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/catalogapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/identityapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/orderingapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/orderingbackgroundtasks --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/orderingsignalrhub --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/paymentapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]'
# patch web shop
oc patch dc/webhooksapi --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webhooksclient --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webmarketingapigw --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webmvc --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webshoppingagg --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webshoppingapigw --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webspa --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/webstatus --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]'
# patch mobile app
oc patch dc/mobilemarketingapigw --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/mobileshoppingagg --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc patch dc/mobileshoppingapigw --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]'

# open Kiali
KIALI_URL="http://$(oc get route kiali -o jsonpath="{.spec.host}" -n istio-system)"
open -a "Google Chrome" $KIALI_URL


###
Error in webmvc
System.InvalidOperationException: IDX20803: Unable to obtain configuration from: 'https://identity-dev.msftnbu.com/.well-known/openid-configuration'.

will replace
-dev.msftnbu.com
-development.apps.cluster-k4pz2.k4pz2.sandbox1929.opentlc.com

https://github.com/tmccart1/eShopOnContainers/tree/feature/openshift-aro
git checkout -t origin/feature/openshift-aro

.\deploy-all-mac.ps1 -imageTag linux-dev -useLocalk8s $true -useMesh $true

ubuntu-16.04
ubuntu-latest

git@github.com:adnan-drina/eShopOnContainers.git
git remote set-url origin git@github.com:adnan-drina/eShopOnContainers.git
git push origin feature/openshift-aro

oc new-project development
