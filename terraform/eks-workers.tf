data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.you.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  you-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.you.endpoint}' --b64-cluster-ca '${aws_eks_cluster.you.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}

resource "aws_launch_configuration" "you" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.you-node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.large"
  name_prefix = "terraform-eks-you"
  security_groups = [aws_security_group.you-node-sg.id]
  user_data_base64 = base64encode(local.you-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "you" {
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.you.id
  max_size = 1
  min_size = 1
  name = "terraform-eks-you"
  vpc_zone_identifier = module.vpc.public_subnets

  tag {
    key = "Name"
    value = "terraform-eks-you"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}

