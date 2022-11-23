# Source-to-image (S2I) build
# The source-to-image strategy creates a new container image based on application source code or application
# binaries. Red Hat OpenShift clones the application source code, or copies the application binaries into a
# compatible builder image, and assembles a new container image that is ready for deployment on the platform.

# Create a new OpenShift project
oc new-project s2i-demo

# Verify that the project is empty
oc get all

# Add the .NET Core application
#oc new-app dotnet:3.1~https://github.com/adnan-drina/s2i-dotnetcore-ex#dotnetcore-3.1 \
#--context-dir app

oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app

# View the status of your app
oc status

# Make the .NET Core application accessible externally
oc expose service s2i-dotnetcore-ex

# Access the service using the Route URL
ROUTE="http://$(oc get route s2i-dotnetcore-ex -o jsonpath="{.spec.host}")"
curl -s $ROUTE | grep Welcome

# Clean it up
oc delete all -l app=s2i-dotnetcore-ex
oc delete project s2i-demo

# Resources Created by the oc new-app Command
# The oc new-app command adds the following resources to the current project to support building and
# deploying an application:
#   - A build configuration to build the application container image from either source code or a Dockerfile.
#   - An image stream pointing to either the generated image in the internal registry or to an existing image in an external registry.
#   - A deployment resource using the image stream as input to create application pods.
#   - A service for all ports that the application container image exposes.


# Check all available image streams
oc get is dotnet -n openshift -o name
# View existing image tags for dotnet
oc get istag -n openshift | grep dotnet
# Show additional information on image and image tag
oc describe is dotnet -n openshift