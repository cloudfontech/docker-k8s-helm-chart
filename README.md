# Deploying a Docker Container to Kubernetes using Helm and Helm Charts - https://cloudfontech.com

When working on large projects that require multiple containers to be deployed to Kubernetes, managing these containers manually can quickly become overwhelming. You'll likely need to write separate deployment files, service files, and other configurations for each container. This process can become a nightmare, especially for larger projects. Fortunately, there's a solution to this problem called Helm.

Helm simplifies the deployment process by allowing you to package all your Kubernetes resources into a single package called a Helm Chart. This guide will walk you through deploying a Docker container to Kubernetes using Helm. By the end of this guide, you'll be able to deploy large projects with a single Helm command.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- **Docker**: If you don't have Docker installed, download it from the [Docker website](https://www.docker.com/products/docker-desktop).
- **Helm**: Follow the installation steps on the [Helm installation guide](https://helm.sh/docs/intro/install/).
- **Kubernetes**: If you're using Docker Desktop, you only need to enable it in the settings. If you're using Minikube, follow the installation steps on the [Minikube installation guide](https://minikube.sigs.k8s.io/docs/start/).

## What is Helm?

Helm is a package manager for Kubernetes applications. It helps you define, install, and manage Kubernetes applications and their dependencies more easily. Think of Helm as similar to package managers like `apt` (for Ubuntu) or `yum` (for CentOS) in the Linux world but tailored explicitly for Kubernetes.

With Helm, you can package all the Kubernetes resources like deployments, services, and configmaps required to run an application into a single package called a Helm Chart. This Helm Chart can then be shared with others, making it easy for them to deploy the application to their Kubernetes cluster.

## What is a Helm Chart?

A Helm chart is a collection of files that describe a set of Kubernetes resources needed to run a particular application. Charts can be versioned, shared, and reused.

A Helm chart has the following structure:

mychart/
Chart.yaml
values.yaml
charts/
templates/
.helmignore


- **Chart.yaml**: Contains metadata about the chart, such as the name, version, and description.
- **values.yaml**: Contains the default values for the chart. These values can be overridden when installing the chart.
- **charts/**: Contains any subcharts on which the chart depends.
- **templates/**: Contains the Kubernetes resource templates that will be deployed to the cluster.
- **.helmignore**: Specifies files that should be ignored when packaging the chart.

## Why Use Helm?

While you can deploy Kubernetes resources manually using `kubectl apply`, Helm provides several benefits:

- **Package Management**: Helm provides a package management system for Kubernetes applications.
- **Reusability**: Helm charts are reusable templates that you can share with others.
- **Versioning and Rollbacks**: Helm allows you to version your Helm charts and releases, enabling easy rollbacks to previous versions.
- **Configuration Management**: Helm charts support parameterization through values files.
- **Dependency Management**: Helm supports chart dependencies, simplifying the deployment process.

## Deploying a Docker Container to Kubernetes using Helm

### Project Setup

This project will involve creating a simple Docker container that serves a static HTML page using Nginx. You'll build and push this Docker image to Docker Hub, then create a Helm chart to deploy this Docker container to a Kubernetes cluster.

### Step 1: Dockerfile

### make sure to copy my index.html, styles.css, main.js, and images folder to your project directory

Create a `Dockerfile` with the following content:

```dockerfile
FROM nginx:alpine
# Remove the default NGINX welcome page
RUN rm -rf /usr/share/nginx/html/*
# Copy the index.html, imgs, styles, js file to the NGINX document root
COPY index.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
COPY main.js /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/


## Build and run the Docker image to test if the project works using docker

docker build -t rock-paper-scissors .
docker run -d -p 8008:80 rock-paper-scissors
check with localhost:8008
docker stop <container id>

### Step 2: Push the Docker Image to Docker Hub

docker login
docker tag rock-paper-scissors iamvieve/rock-paper-scissors:latest
docker push iamvieve/rock-paper-scissors:latest

### Step 3: Create a Helm Chart
Create a new Helm chart named rock-paper-scissors:

helm create rock-paper-scissors

### Edit the values.yaml file in the rock-paper-scissors directory to customize the chart values. Update the image name, repo name, and tag: latest.

### Step 4: Deploy the Helm Chart to Kubernetes
Start Minikube and install the Helm chart:

minikube start
helm install my-release-rps ./rock-paper-scissors

### If this is your first time deploying a Helm chart, you may see a message with instructions on accessing your application:

NAME: my-release
LAST DEPLOYED: Fri Apr 26 14:31:05 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
    1. Get the application URL by running these commands:
    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=helm-nginx,app.kubernetes.io/instance=my-release" -o jsonpath="{.items[0].metadata.name}")
    export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
    echo "Visit http://127.0.0.1:8080 to use your application"
    kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT


# Run the export commands from the instruction you received
export 1
export 2

Verify that the deployment was successful by checking the status of the pods if it says running:

kubectl get pods
kubectl get services

### Access the application by running the command from the Helm output:

kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT

Navigate to http://localhost:8080 in your web browser to access the application.

### Step 5: Clean Up
Uninstall the Helm release and clean up the resources:

helm uninstall my-release-rps
