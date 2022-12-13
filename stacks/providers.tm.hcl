# This file is part of Terramate Configuration.
# Terramate is an orchestrator and code generator for Terraform.
# Please see https://github.com/mineiros-io/terramate for more information.
#
# To generate/update Terraform code within the stacks
# run `terramate generate` from root directory of the repository.

##############################################################################
# Generate terraform files in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block

generate_hcl "_generated_providers.tf" {
  content {
    # the default values of globals are defined in config.tm.hcl in this directory
    provider "aws" {
      region  = global.terraform_provider_aws_config_region
      profile = global.terraform_provider_aws_config_profile
    }
  }
}

generate_hcl "_generated_versions.tf" {
  content {
    terraform {
      required_version = global.terraform_version
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = global.terraform_aws_provider_version
        }
      }
    }
  }
}
