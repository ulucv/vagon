module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  cidr    = var.vpc_cidr
  name    = var.vpc_name
  azs     = data.aws_availability_zones.current_zones.names
  secondary_cidr_blocks = var.secondary_cidr_block
  private_subnets = concat(
    [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(var.vpc_cidr, 8, k)],
    [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(element(var.secondary_cidr_block, 0), 4, k)],
    #[for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(element(secondary_cidr_blocks, 1), 4, k)], add this after changing extra cidr range in case more ip needed
  )
  public_subnets      = [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  elasticache_subnets = [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(var.vpc_cidr, 8, k + 12)]
  intra_subnets       = [for k, v in data.aws_availability_zones.current_zones.names : cidrsubnet(var.vpc_cidr, 8, k + 20)]
  create_database_subnet_group = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = var.tag_eks
    Tier = "vagon-private-subnet-${var.env}"
    Type = "Private"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    Tier = "vagon-public-subnet-${var.env}"
    Type = "Public"
  }
  elasticache_subnet_tags = {
    Tier = "vagon-elasticache-subnet-${var.env}"
    Type = "Elasticache"
  }
  intra_subnet_tags = {
    Tier = "vagon-intra-subnet-${var.env}"
    Type = "Intra"
  }
  database_subnet_group_tags = {
    Tier = "vagon-database-subnet-${var.env}"
    Type = "Database"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
  #enable_vpn_gateway = true
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_type
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  vpc_flow_log_iam_role_name            = var.vpc_flow_log_role_name
  vpc_flow_log_iam_role_use_name_prefix = false
  enable_flow_log                       = true
  create_flow_log_cloudwatch_log_group  = true
  create_flow_log_cloudwatch_iam_role   = true
  flow_log_max_aggregation_interval     = 60
}