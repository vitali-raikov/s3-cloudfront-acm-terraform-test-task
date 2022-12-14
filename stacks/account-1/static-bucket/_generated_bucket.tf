// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "bolt.crabdance.com"
  ignore_public_acls      = true
  restrict_public_buckets = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  source = "terraform-aws-modules/s3-bucket/aws"
  versioning = {
    enabled = true
  }
}
