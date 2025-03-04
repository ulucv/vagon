terraform {
  source = "../../../..//infra/modules/vpc"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
  }
  before_hook "checkov" {
    commands = ["plan"]
    execute = [
      "checkov",
      "-d",
      ".",
      "--download-external-modules",
      "true",
      "--skip-check",
      "CKV_TF_1",  #Skip module hash since its directly fetched from global terraform registiries
      "--quiet",
      "--framework",
      "terraform",
    ]
  }
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region = local.region_vars.locals.aws_region
  env = local.environment_vars.locals.environment
  vpc_name = "vagon-${local.env}-vpc"
  tag = "vagon-eks-${local.env}-demo"
}

inputs = {
  vpc_name = local.vpc_name
  vpc_flow_log_role_name = "vpc-flow-role-${local.env}"
  tag_eks = local.tag
  env = local.tag
  region = local.region
  domain_name = "vagon.com"
}