// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_route53_record" "acm_verification" {
  allow_overwrite = true
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name = each.value.name
  records = [
    each.value.record,
  ]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.this.zone_id
}
resource "aws_acm_certificate_validation" "acm_verification" {
  certificate_arn = aws_acm_certificate.this.arn
  depends_on = [
    aws_route53_record.acm_verification,
  ]
  provider                = aws.infra
  validation_record_fqdns = [for record in aws_route53_record.acm_verification : record.fqdn]
}
