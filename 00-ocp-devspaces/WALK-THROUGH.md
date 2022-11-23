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
oc new-build --name=mywebapp dotnet:6.0 --binary=true
oc start-build mywebapp --from-dir=./bin/Release/net6.0/publish
oc new-app mywebapp
```