# Pipelines as Code provide a powerful CLI designed to work with tkn plug-in
# https://pipelinesascode.com/docs/guide/cli/#install
# brew install openshift-pipelines/pipelines-as-code/tektoncd-pac

# Start with bootstrap process
# tkn pac bootstrap dotnet-demo

# Install OpenShift Pipelines
# Log into the OpenShift cluster as an administrator and install OpenShift Pipelines.
oc apply -f ./02-ocp-pipelines/tekton-sub.yaml

# Step 1: Create a new pipeline project
oc new-project dotnet-pipeline-app

# Let's deploy our app first
oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app

# Step 2: Define a PipelineResource
# The git PipelineResource indicates a Git repository, which is often used as in the input to a Pipeline or Task.
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: simple-dotnet-project-source
spec:
  type: git
  params:
    - name: revision
      value: dotnetcore-3.1-openshift-manual-pipeline
    - name: url
      value: https://github.com/adnan-drina/s2i-dotnetcore-ex

# Step 3: Define the pipeline
# A Pipeline is a collection of Tasks. It lets us group Tasks and run them in a particular order.
apapiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: simple-dotnet-pipeline
spec:
  resources:
    - name: source-repository
      type: git
  tasks:
    - name: simple-build-and-test
      taskRef:
        name: simple-publish
      resources:
        inputs:
          - name: source
            resource: source-repository

# Step 4: Define and build a task
# Task is a collection of steps that we want to run in order.
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: simple-publish
spec:
  resources:
    inputs:
      - name: source
        type: git
  steps:
    - name: simple-dotnet-publish
      image: registry.access.redhat.com/ubi8/dotnet-31 # .NET Core SDK
      securityContext:
        runAsUser: 0  # UBI 8 images generally run as non-root
      script: |
          #!/usr/bin/bash
          dotnet --info
          cd source
          dotnet publish -c Release -r linux-x64 --self-contained false "app/app.csproj"

# We can now apply it to our OpenShift instance
oc apply -f ./02-ocp-pipelines/demo-pipeline.yaml

# Step 6: Run the pipeline
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  generateName: run-simple-dotnet-pipeline-
spec:
  pipelineRef:
    name: simple-dotnet-pipeline
  resources:
    - name: source-repository
      resourceRef:
        name: simple-dotnet-project-source

# Run the following in order to create a service account named pipeline on OpenShift
# and allow it to run privileged containers
oc create serviceaccount pipeline
oc adm policy add-scc-to-user privileged -z pipeline
oc adm policy add-role-to-user edit -z pipeline

# Run the pipeline
oc create -f ./02-ocp-pipelines/run-demo-pipeline.yaml

# Let's clean things up
oc delete all -l app=dotnet-demo
oc delete project dotnet-pipeline-app