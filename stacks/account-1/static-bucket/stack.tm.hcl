stack {
  name = "Account A - S3 static bucket"

  after = [
    "../tfstate-bucket",
  ]
}
