module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "you_cluster"
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "you"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "hello-world-app-group-1"
      instance_type                 = "t2.micro"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.helloworld_access.id,aws_security_group.worker_group_mgmt_one.id]
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
