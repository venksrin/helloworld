# helloworld
Hello world App
This directory contains the main.go file which is the "Hello World" application from Google.
The manifest Directory contains the K8 Manifests to create the deployments, Secret, Service and Ingress manifests to create the k8 objects
The terraform directory has the Terraform scripts to launch a EKS K8 cluster in AWS

# Build and Deploy
Build and Deploy is handled via the github actions workflow .github/workflows/hello-world.yaml

## Launching your EKS Cluster
EKS Cluster will be brought up via Terraform scripts
Initialize Terraform to download the required modules, then run terraform plan to review and terraform up
```
terraform init
terraform plan
terraform apply
```
Deploy the app using skaffold dev to build and deploy the hello world application


