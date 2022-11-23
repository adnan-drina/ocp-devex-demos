https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/developing_.net_applications_in_rhel_8/using-net-core-on-ocp_gsg

# Introduction to Devspaces

---

These steps can be executed from your local IDE or from OpenShift DevSpaces.
If you plan to use DevSpaces please make sure that the env is configured upfront.
The env setup is scripted in ./devspaces-setup

---

Let's test make a simple notNet HelloWorld app

```shell
dotnet new web -o webapp
cd webapp
dotnet publish -c Release
```

Let's make sure we are connected to our OCP cluster
```shell
oc login
```

Now we can create a Kubernetes project for our development
```shell
oc new-project my-dev-sandbox
```

Now let's integrate our build process with OCP
```shell
oc new-build dotnet:6.0 --binary --name=mywebapp -l app=mywebapp
oc start-build mywebapp --from-dir=./bin/Release/net6.0/publish --follow
```
Once the build is done, we’ll deploy.
```shell
oc new-app mywebapp
```
and run this to expose our service to the world and add a health check:

```shell
oc expose service/mywebapp \
&& oc set probe deployment/mywebapp  --readiness --get-url=http://:8080 --initial-delay-seconds=5 --period-seconds=5 --failure-threshold=15
```

now evryone can access our app from the web using a route
```shell
oc get route mywebapp
```

Now let's make a change in our app Program.cs
Build our app locally and deploy it to OCP

```shell
dotnet publish -c Release
oc start-build mywebapp --from-dir=./bin/Release/net6.0/publish
```
After refreshing the URL we should see changes


Now we can delete everything 
```shell
oc delete all -l app=mywebapp
oc delete project my-dev-sandbox
```