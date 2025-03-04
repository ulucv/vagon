# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform and OpenTofu that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/eks-addons.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "eks" {
  config_path = "../eks"
}

# ---------------------------------------------------------------------------------------------------------------------
# Override parameters for this environment
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  private_subnet_ids                 = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids                  = dependency.vpc.outputs.public_subnet_ids
  intra_subnet_ids                   = dependency.vpc.outputs.intra_subnet_ids
  vpc_id                             = dependency.vpc.outputs.vpc_id
  vpc_cidr                           = dependency.vpc.outputs.vpc_cidr_block
  kubernetes_version                 = "1.30"
  domain_name                        = "vagon.com"
  cluster_endpoint                   = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_version                    = dependency.eks.outputs.cluster_version
  oidc_provider_arn                  = dependency.eks.outputs.oidc_provider_arn
  addons = {
    enable_aws_load_balancer_controller = true
    enable_metrics_server               = true
  }
}
