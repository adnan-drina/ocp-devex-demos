https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/developing_.net_applications_in_rhel_8/using-net-core-on-ocp_gsg

dotnet new web -o webapp
cd webapp
dotnet publish -c Release

oc new-build --name=mywebapp dotnet:6.0 --binary=true
oc start-build mywebapp --from-dir=./bin/Release/net6.0/publish
oc new-app mywebapp