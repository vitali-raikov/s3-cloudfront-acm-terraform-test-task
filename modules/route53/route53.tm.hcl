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

generate_hcl "_generated_zone.tf" {
  content {
    resource "aws_route53_zone" "this" {
      name = global.domain_name
    }
  }
}

generate_hcl "_generated_outputs.tf" {
  content {
    output "route53_name_servers" {
      description = "Route53 name servers"
      value       = aws_route53_zone.this.name_servers
    }
  }
}
