stack {
  id   = "route53"
  name = "Account B - Route53"

  after = [
    "../tfstate-bucket",
  ]
}
