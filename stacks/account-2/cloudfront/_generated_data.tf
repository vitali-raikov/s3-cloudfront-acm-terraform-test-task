// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_acm_certificate" "this" {
  domain   = "bolt.crabdance.com"
  provider = aws.infra
  statuses = [
    "ISSUED",
  ]
}
data "aws_route53_zone" "this" {
  name = "bolt.crabdance.com"
}
data "aws_s3_bucket" "static" {
  bucket   = "bolt.crabdance.com"
  provider = aws.account-1
}
