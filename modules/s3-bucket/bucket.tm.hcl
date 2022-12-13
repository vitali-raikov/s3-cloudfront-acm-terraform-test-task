# This file is part of Terramate Configuration.
# Terramate is an orchestrator and code generator for Terraform.
# Please see https://github.com/mineiros-io/terramate for more information.
#
# To generate/update Terraform code within the stacks
# run `terramate generate` from root directory of the repository.

##############################################################################
# Defaults for each service account that can be overwritten in stacks below
globals {
  # The default name of a cloud run application is terramate-{stack_basename}-{environment}
  s3_bucket_name = "${global.account_name}-${terramate.stack.path.basename}"

  # Controls private or public access to bucket
  s3_acl                     = "private"
  s3_block_public_acls       = true
  s3_block_public_policy     = true
  s3_restrict_public_buckets = true
  s3_ignore_public_acls      = true

  # Whethever versioning is enabled or not
  s3_versioning = true
}

##############################################################################
# Generate terraform files in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block

generate_hcl "_generated_bucket.tf" {
  content {
    module "s3_bucket" {
      source = "terraform-aws-modules/s3-bucket/aws"

      bucket = global.s3_bucket_name

      acl                     = global.s3_acl
      block_public_acls       = global.s3_block_public_acls
      block_public_policy     = global.s3_block_public_policy
      restrict_public_buckets = global.s3_restrict_public_buckets
      ignore_public_acls      = global.s3_ignore_public_acls

      versioning = {
        enabled = global.s3_versioning
      }
    }
  }
}

generate_hcl "_generated_outputs.tf" {
  content {
    output "bucket_arn" {
      description = "Bucket ARN"
      value       = module.s3_bucket.s3_bucket_arn
    }
  }
}
