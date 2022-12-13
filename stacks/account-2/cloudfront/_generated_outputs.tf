// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

output "cloudformation_distribution_arn" {
  description = "Cloudformation Distribution ARN"
  value       = aws_cloudfront_distribution.s3_distribution.arn
}
output "cloudformation_domain_name" {
  description = "Cloudformation Domain Name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}
