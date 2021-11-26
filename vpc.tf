module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.59.0"

  name = "you-vpc"
  cidr = "10.1.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    "Name"                                      = "you-terraform-eks"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

