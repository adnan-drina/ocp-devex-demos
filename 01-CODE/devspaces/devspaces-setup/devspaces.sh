#Install Devspaces operator (might take up to 5 min to complete)
oc create -f ./00-ocp-devspaces/devspaces-setup/devspaces-sub.yaml

#Install Devspaces
oc create -f ./00-ocp-devspaces/devspaces-setup/devspaces-ns.yaml
oc create -f ./00-ocp-devspaces/devspaces-setup/checluster.yaml

#Access your devspaces
oc get route devspaces -o template --template='{{.spec.host}}' -n openshift-devspaces
