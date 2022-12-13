// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_acm_certificate" "this" {
  domain_name       = "bolt.crabdance.com"
  provider          = aws.infra
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
