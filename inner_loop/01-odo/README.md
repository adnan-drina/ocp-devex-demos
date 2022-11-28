# 5-minute demo: odo - Developer-focused CLI for fast & iterative application development on Kubernetes
For more information, please see the [official product documentation](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.11/html/cli_tools/developer-cli-odo) or have a look at the [community documentation](https://odo.dev/docs/introduction).

## Table of Contents
- **[Introduction to odo](#introduction-to-odo)**<br>
- **[Set up a dev environment on OpenShift](#lets-set-things-up)**<br>
- **[Initialize your odo workspace](#initializing-your-application)**<br>
- **[Developing Continuously with odo](#developing-your-application-continuously)**<br>
- **[](#)**<br>
---

## Introduction to odo
odo is a fast, and iterative CLI tool for developers who write, build, and deploy applications on Kubernetes and OpenShift.

### Why use odo?

* Fast: Spend less time maintaining your application deployment infrastructure and more time coding. Immediately have your application running each time you save.
* Standalone: odo is a standalone tool that communicates directly with the Kubernetes API. There is no requirement for a daemon or server process.
* No configuration needed: There is no need to dive into complex Kubernetes yaml configuration files. odo abstracts those concepts away and lets you focus on what matters most: code.
* Containers first: We provide first class support for both Kubernetes and OpenShift. Choose your favourite container orchestrator and develop your application.
* Easy to learn: Simple syntax and design centered around concepts familiar to developers, such as projects, applications, and components.

---

## Let's set things up

### Create a simple dotnet Hello World application

```shell
dotnet new mvc --name app
cd app
```

### Login to OpenShift Cluster
The easiest way to connect odo to an OpenShift cluster is use copy "Copy login command" function in OpenShift Web Console.

**Note:** If you dont have an OpenShift cluster available, you can use [OpenShift Developer Sandbox](https://developers.redhat.com/developer-sandbox).
The sandbox is perfect for immediate access into OpenShift. With the sandbox, you'll get free access to a shared OpenShift and Kubernetes cluster.

* Login to OpenShift Web Console.
* At the top right corner click on your username and then on "Copy login command".
* You will be prompted to enter your login credentials again.
* After login, open "Display Token" link.
* Copy whole oc login --token ... command and paste it into the terminal, before executing the command replace oc with odo.


### Create a new project
If you are using OpenShift, you can create a new namespace with the odo create project command.

```shell
$ odo create project odo-dev
 ✓  Project "odo-dev" is ready for use
 ✓  New project created and now using namespace: odo-dev
 ```

---

### Initializing your application

Now we'll initialize your application by creating a devfile.yaml to be deployed.

odo handles this automatically with the odo init command by autodetecting your source code and downloading the appropriate Devfile.

Note: If you skipped generating a new application previously, select a "starter project" when running odo init.

Let's run odo init and select .NET:

```shell
$ odo init
  __
 /  \__     Initializing new component
 \__/  \    Files: Source code detected, a Devfile will be determined based upon source code autodetection
 /  \__/    odo version: v3.0.0~beta3
 \__/


Interactive mode enabled, please answer the following questions:
Based on the files in the current directory odo detected
Language: dotnet
Project type: dotnet
The devfile "nodejs" from the registry "DefaultDevfileRegistry" will be downloaded.
? Is this correct? Yes
 ✓  Downloading devfile "dotnet" from registry "DefaultDevfileRegistry" [501ms]
Current component configuration:
Container "runtime":
  Opened ports:
   - 8080
  Environment variables:
? Select container for which you want to change configuration? NONE - configuration is correct
? Enter component name: my-dotnet-app


Your new component 'my-dotnet-app' is ready in the current directory.
To start editing your component, use 'odo dev' and open this folder in your favorite IDE.
Changes will be directly reflected on the cluster.
 ```
A devfile.yaml has now been added to your directory and now you're ready to start development.

---

### Developing your application continuously

Now that we've generated our code as well as our Devfile, let's start on development.

odo uses inner loop development and allows you to code, build, run and test the application in a continuous workflow.

Once you run odo dev, you can freely edit code in your favourite IDE and watch as odo rebuilds and redeploys it.

Let's run odo dev to start development on your .NET application:

```shell
odo dev
  __
 /  \__     Developing using the my-dotnet-app Devfile
 \__/  \    Namespace: default
 /  \__/    odo version: v3.0.0~beta3
 \__/


↪ Deploying to the cluster in developer mode
 ✓  Waiting for Kubernetes resources [3s]
 ✓  Syncing files into the container [330ms]
 ✓  Building your application in container on cluster [4s]
 ✓  Executing the application [1s]


Your application is now running on the cluster
 - Forwarding from 127.0.0.1:40001 -> 8080


Watching for changes in the current directory /Users/user/dotnet
Press Ctrl+c to exit `odo dev` and delete resources from the cluster
 ```

You can now access the application at http://localhost:40001 in your local browser and start your development loop. odo will watch for changes and push the code for real-time updates.

---

## Git Branches

//TODO

 ## Key takeaways

//TODO

 ## Clean things up

//TODO