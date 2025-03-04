terraform {
  source = "../../../..//infra/modules/eks-addons"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
  }

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
  tag_eks = local.tag
  gitops_addons_org  = "https://github.com/gitops-bridge-dev"
  gitops_addons_repo = "gitops-bridge-argocd-control-plane-template"
  gitops_addons_revision = "main"
  gitops_addons_basepath = ""
  gitops_addons_path = "bootstrap/control-plane/addons"
  cluster_name = "vagon-eks-${local.env}-demo"
  region = local.region
  env = local.env
}
