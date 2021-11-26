resource "aws_eks_cluster" "you" {
  name     = var.cluster-name
  role_arn = aws_iam_role.you-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.you-cluster-sg.id]
    subnet_ids = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.you-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.you-cluster-AmazonEKSServicePolicy,
  ]
}

