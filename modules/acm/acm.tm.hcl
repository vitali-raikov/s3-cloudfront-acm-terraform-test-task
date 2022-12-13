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

generate_hcl "_generated_acm_provider.tf" {
  content {
    # the default values of globals are defined in config.tm.hcl in this directory
    provider "aws" {
      alias   = "infra"
      region  = "us-east-1"
      profile = global.terraform_provider_aws_config_profile
    }
  }
}

generate_hcl "_generated_acm.tf" {
  content {
    resource "aws_acm_certificate" "this" {
      provider          = aws.infra
      domain_name       = global.domain_name
      validation_method = "DNS"

      lifecycle {
        create_before_destroy = true
      }
    }
  }
}

generate_hcl "_generated_data.tf" {
  content {
    data "aws_route53_zone" "this" {
      name = global.domain_name
    }
  }
}

generate_hcl "_generated_acm_verification.tf" {
  content {
    resource "aws_route53_record" "acm_verification" {
      for_each = {
        for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
          name   = dvo.resource_record_name
          record = dvo.resource_record_value
          type   = dvo.resource_record_type
        }
      }

      allow_overwrite = true
      name            = each.value.name
      records         = [each.value.record]
      ttl             = 60
      type            = each.value.type
      zone_id         = data.aws_route53_zone.this.zone_id
    }

    resource "aws_acm_certificate_validation" "acm_verification" {
      provider                = aws.infra
      certificate_arn         = aws_acm_certificate.this.arn
      validation_record_fqdns = [for record in aws_route53_record.acm_verification : record.fqdn]

      depends_on = [
        aws_route53_record.acm_verification
      ]
    }
  }
}
