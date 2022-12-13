# This file is part of Terramate Configuration.
# Terramate is an orchestrator and code generator for Terraform.
# Please see https://github.com/mineiros-io/terramate for more information.
#
# To generate/update Terraform code within the stacks
# run `terramate generate` from root directory of the repository.

globals {
  ### TERRAFORM ###############################################################

  ### global variables for use when generating providers
  # all variables defined here can be overwritten in any sub-directory and on the
  # stack level

  # The global terraform version to use
  terraform_version = "~> 1.0"

  # aws provider settings
  terraform_provider_aws_config_region = "eu-north-1"
  terraform_backend_aws_region         = "eu-north-1"
  terraform_aws_provider_version       = "~> 4.45"

  ### global variables for use when generating backend
  # all variables defined here can be overwritten in any sub-directory and on the
  # stack level

  # to demonstrate how to use gloabls in backend configuration
  # the same way you could define state buckets and path within the bucket
  # e.g. setting prefix to terramate.path
  # we use terraforms default for local backends here
  local_tfstate_path = "terraform.tfstate"

  ### GLOBALS ##################################################################

  # global variables for use in terraform code within stacks
  # we use providers project and location by default
  location = global.terraform_provider_aws_config_region

  use_remote_state = true

  # This is the static domain name created in freedns.afraid.org
  domain_name       = "bolt.crabdance.com"
  s3_tfstate_bucket = "test-task-${global.account_name}-tfstate"

  project_name   = "bolt"
  account_name_1 = "account-1"
  account_name_2 = "account-2"
}
