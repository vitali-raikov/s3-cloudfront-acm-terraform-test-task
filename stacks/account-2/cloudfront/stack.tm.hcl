stack {
  name = "Account B - Cloudfront"

  after = [
    "../tfstate-bucket",
    "../route53",
  ]
}
