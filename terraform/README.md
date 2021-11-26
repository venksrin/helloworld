# Setting up AWS EKS (Hosted Kubernetes)

See https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html for full guide


## Download the aws-iam-authenticator
```
wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64
chmod +x heptio-authenticator-aws_0.3.0_linux_amd64
sudo mv heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/heptio-authenticator-aws
```

## Terraform apply
```
terraform init
terraform apply
```

## Configure kubectl
```
terraform output kubeconfig >  ~/.kube/config
aws eks --region <region> update-kubeconfig --name terraform-eks-you
```

## Configure config-map-auth-aws
```
terraform output config-map-aws-auth > config-map-aws-auth.yaml
kubectl apply -f config-map-aws-auth.yaml
```

## See nodes coming up
```
kubectl get nodes
```

