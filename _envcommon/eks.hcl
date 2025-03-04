terraform {
  source = "../../../..//infra/modules/eks"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
  }
  #before_hook "checkov" {
  #  commands = ["plan"]
  #  execute = [
  #    "checkov",
  #    "-d",
  #    ".",
  #    #"--download-external-modules",
  #    #"true",
  #    "--skip-check",
  #    "CKV_TF_1",  #Skip module hash since its directly fetched from global terraform registiries
  #    "--quiet",
  #    "--framework",
  #    "terraform",
  #  ]
  #}
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region = local.region_vars.locals.aws_region
  env = local.environment_vars.locals.environment
  tag = "vagon-eks-${local.env}-demo"
  account = local.account_vars.locals.aws_account_id
}

inputs = {
  vpc_flow_log_role_name = local.region
  cluster_name = "vagon-eks-${local.env}-demo"
  tag_eks = local.tag
  account =local.tag
}