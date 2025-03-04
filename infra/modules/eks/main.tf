module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  #create_kms_key = true
  enable_irsa = true
  #Added most recent for the remaining resources on the EKS main plugin resources
  cluster_enabled_log_types = var.cluster_enabled_log_types
  cluster_addons = {
    coredns                = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy             = {
      most_recent = true
    }
    vpc-cni = {
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.intra_subnet_ids

  # EKS Managed Node Group(s)
  #eks_managed_node_group_defaults = {
  #  instance_types = ["t3.small"]
  #}
  cluster_security_group_additional_rules = {
    kubectl_in_vpn_client_sg = {
      description = "Kubectl In VPN"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = var.vpn_cidr_block
    }
  }

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]
      #Added this line for adding EBS role for EBS related operations , need mostly for jitsi
      iam_role_additional_policies = {
        EBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        #AWSLoadBalancerControllerIAMPolicy =  "arn:aws:iam::${var.account}:policy/AWSLoadBalancerControllerIAMPolicy"
      }
      min_size     = 1
      max_size     = 3
      desired_size = 1

      #Not needed for now
      taints = {
        # This Taint aims to keep just EKS Addons and Karpenter running on this MNG
        # The pods that do not tolerate this taint should run on nodes created by Karpenter
        addons = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        },
      }
    }
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    #node_security_group_tags = {
    #  "karpenter.sh/discovery" = var.tag_eks
    #}
    #node_security_group_tags  = {
    #  "karpenter.sh/discovery" = var.cluster_name
    #}
    tags = {
      "karpenter.sh/discovery" = var.tag_eks
    }
  }
  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access  = true #-> change it to false
  cluster_endpoint_private_access = false
  tags = {
    Terraform   = "true"
    "karpenter.sh/discovery" = var.tag_eks
  }
}