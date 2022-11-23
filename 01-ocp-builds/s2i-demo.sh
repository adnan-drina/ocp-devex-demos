# Create a new OpenShift project
oc new-project s2i-demo

# Add the .NET Core application
oc new-app --name=dotnet-demo 'dotnet:6.0-ubi8~https://github.com/redhat-developer/s2i-dotnetcore-ex#dotnet-6.0' \
--build-env DOTNET_STARTUP_PROJECT=app

# Make the .NET Core application accessible externally
oc expose service s2i-dotnetcore-ex

# Access the service using the Route URL
ROUTE="http://$(oc get route s2i-dotnetcore-ex -o jsonpath="{.spec.host}")"
curl -s $ROUTE | grep Welcome