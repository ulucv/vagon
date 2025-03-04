terraform {
  source = "../../../..//infra/modules/s3"
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
      "--skip-check",
      "CKV_TF_2",  #Skip module hash since its directly fetched from global terraform registiries
      "--skip-check",
      "CKV_AWS_300", #Skip since module check fails , not client side configs
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
}

inputs = {
  bucketname = "vagon-s3-bucket-${local.env}-${local.region}-demo"
}