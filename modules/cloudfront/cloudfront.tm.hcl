# This file is part of Terramate Configuration.
# Terramate is an orchestrator and code generator for Terraform.
# Please see https://github.com/mineiros-io/terramate for more information.
#
# To generate/update Terraform code within the stacks
# run `terramate generate` from root directory of the repository.

##############################################################################
# Defaults for each service account that can be overwritten in stacks below
globals {
  cloudfront_enabled             = true
  cloudfront_default_root_object = "index.html"
  cloudfront_price_class         = "PriceClass_100"

  cloudfront_cache_allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cloudfront_cache_cached_methods  = ["GET", "HEAD"]
  cloudfront_cache_query_string    = false
  cloudfront_cache_cookies         = "none"

  cloudfront_cache_min_ttl     = 0
  cloudfront_cache_default_ttl = 3600
  cloudfront_cache_max_ttl     = 86400

  cloudfront_ssl_policy       = "redirect-to-https"
  cloudfront_ssl_method       = "sni-only"
  cloudfront_ssl_default_cert = false
  cloudfront_ssl_min_version   = "TLSv1.2_2021"
}

##############################################################################
# Generate terraform files in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block

generate_hcl "_generated_extra_providers.tf" {
  content {
    # the default values of globals are defined in config.tm.hcl in this directory
    provider "aws" {
      alias   = "infra"
      region  = "us-east-1"
      profile = global.terraform_provider_aws_config_profile
    }

    # This is AWS provider for a different account where static bucket is located
    provider "aws" {
      alias   = global.account_name_1
      region  = global.terraform_provider_aws_config_region
      profile = "${global.project_name}-${global.account_name_1}"
    }
  }
}
generate_hcl "_generated_data.tf" {
  content {
    data "aws_acm_certificate" "this" {
      provider = aws.infra
      domain   = global.domain_name
      statuses = ["ISSUED"]
    }

    data "aws_route53_zone" "this" {
      name = global.domain_name
    }

    data "aws_s3_bucket" "static" {
      provider = tm_hcl_expression("aws.${global.account_name_1}")
      bucket   = global.domain_name
    }
  }
}

generate_hcl "_generated_cloudfront.tf" {
  content {
    resource "aws_cloudfront_origin_access_control" "this" {
      name                              = global.domain_name
      description                       = "Cloudfront origin access control for access to S3 bucket"
      origin_access_control_origin_type = "s3"
      signing_behavior                  = "always"
      signing_protocol                  = "sigv4"
    }

    resource "aws_cloudfront_origin_access_identity" "restrict_direct_access" {
      comment = "Restrict access to S3 bucket only from Cloudfront"
    }

    resource "aws_cloudfront_distribution" "s3_distribution" {
      origin {
        domain_name              = "${global.domain_name}.s3.${global.terraform_provider_aws_config_region}.amazonaws.com"
        origin_id                = global.domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.this.id
      }

      aliases = [
        global.domain_name
      ]

      enabled             = global.cloudfront_enabled
      is_ipv6_enabled     = true
      default_root_object = global.cloudfront_default_root_object
      price_class         = global.cloudfront_price_class

      default_cache_behavior {
        allowed_methods  = global.cloudfront_cache_allowed_methods
        cached_methods   = global.cloudfront_cache_cached_methods
        target_origin_id = global.domain_name

        forwarded_values {
          query_string = global.cloudfront_cache_query_string

          cookies {
            forward = global.cloudfront_cache_cookies
          }
        }

        viewer_protocol_policy = global.cloudfront_ssl_policy
        min_ttl                = global.cloudfront_cache_min_ttl
        default_ttl            = global.cloudfront_cache_default_ttl
        max_ttl                = global.cloudfront_cache_max_ttl
      }

      restrictions {
        geo_restriction {
          restriction_type = "none"
          locations        = []
        }
      }

      viewer_certificate {
        cloudfront_default_certificate = global.cloudfront_ssl_default_cert
        ssl_support_method             = global.cloudfront_ssl_method
        minimum_protocol_version       = global.cloudfront_ssl_min_version
        acm_certificate_arn            = data.aws_acm_certificate.this.arn
      }
    }
  }
}

# Automatically create route53 record pointing to newly created Cloudfront distribution
generate_hcl "_generated_record.tf" {
  content {
    resource "aws_route53_record" "s3_distribution" {
      zone_id = data.aws_route53_zone.this.zone_id
      name    = global.domain_name
      type    = "A"

      alias {
        name                   = aws_cloudfront_distribution.s3_distribution.domain_name
        zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
        evaluate_target_health = false
      }
    }
  }
}

# Update static bucket S3 policy
generate_hcl "_generated_bucket_policy.tf" {
  content {
    data "aws_iam_policy_document" "s3_policy" {
      statement {
        actions   = ["s3:GetObject"]
        resources = ["${data.aws_s3_bucket.static.arn}/*"]

        principals {
          type        = "Service"
          identifiers = ["cloudfront.amazonaws.com"]
        }

        condition {
          test     = "StringEquals"
          variable = "AWS:SourceArn"

          values = [
            aws_cloudfront_distribution.s3_distribution.arn,
          ]
        }
      }
    }

    resource "aws_s3_bucket_policy" "restrict_direct_access" {
      provider = tm_hcl_expression("aws.${global.account_name_1}")
      bucket   = data.aws_s3_bucket.static.id
      policy   = data.aws_iam_policy_document.s3_policy.json
    }
  }
}

generate_hcl "_generated_outputs.tf" {
  content {
    output "cloudformation_distribution_arn" {
      description = "Cloudformation Distribution ARN"
      value       = aws_cloudfront_distribution.s3_distribution.arn
    }

    output "cloudformation_domain_name" {
      description = "Cloudformation Domain Name"
      value       = aws_cloudfront_distribution.s3_distribution.domain_name
    }
  }
}
