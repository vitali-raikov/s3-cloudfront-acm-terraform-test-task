// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

output "route53_name_servers" {
  description = "Route53 name servers"
  value       = aws_route53_zone.this.name_servers
}
