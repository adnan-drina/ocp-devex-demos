
##build and deploy from source
#oc create -f ./demo/demo-namespaces.yaml
#sh ./demo/istio/scripts/deploy-inventory.sh  && \
#sh ./demo/istio/scripts/deploy-catalog.sh 3m

oc apply -k ./demo/inventory/gitops/coolstore-inventory/env/overlays && \
oc apply -k ./demo/inventory/gitops/coolstore-inventory/apps/app-coolstore-inventory/overlays

oc apply -k ./demo/catalog/gitops/coolstore-catalog/env/overlays && \
oc apply -k ./demo/catalog/gitops/coolstore-catalog/apps/app-coolstore-catalog/overlays

oc create -f ./demo/service-mesh-member-roll.yaml

oc patch deployment/inventory-database -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}' -n coolstore-inventory && \
oc patch deployment/catalog-database -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}' -n coolstore-catalog && \
oc patch deployment/inventory -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}' -n coolstore-inventory && \
oc patch deployment/catalog -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}' -n coolstore-catalog
