# Step 1: Create a new pipeline project
oc new-project dotnet-pipeline-app

# Let's deploy our app first
oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app

# We can now apply it to our OpenShift instance
oc apply -f ./02-ocp-pipelines/demo-pipeline.yaml

# Run the following in order to create a service account named pipeline on OpenShift and allow it to run privileged containers
oc create serviceaccount pipeline
oc adm policy add-scc-to-user privileged -z pipeline
oc adm policy add-role-to-user edit -z pipeline

# Run the pipeline
oc create -f ./02-ocp-pipelines/run-demo-pipeline.yaml