stack {
  id   = "acm"
  name = "Account B - AWS Certificate Manager"

  after = [
    "../tfstate-bucket",
    "../route53",
  ]
}
