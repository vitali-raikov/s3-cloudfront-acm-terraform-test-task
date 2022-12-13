// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_route53_record" "s3_distribution" {
  name    = "bolt.crabdance.com"
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}
