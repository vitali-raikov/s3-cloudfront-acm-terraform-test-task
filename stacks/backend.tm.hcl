##############################################################################
# Generate terraform files in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block

generate_hcl "_generated_backend_local.tf" {
  condition = global.use_remote_state == false

  content {
    terraform {
      backend "local" {
        path = "terraform.tfstate"
      }
    }
  }
}

generate_hcl "_generated_backend_remote.tf" {
  condition = global.use_remote_state == true

  content {
    terraform {
      backend "s3" {
        bucket  = global.s3_tfstate_bucket
        key     = "${terramate.stack.path.relative}/terraform.tfstate"
        region  = global.terraform_backend_aws_region
        profile = global.terraform_provider_aws_config_profile
      }
    }
  }
}
