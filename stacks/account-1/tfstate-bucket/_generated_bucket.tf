// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "s3_bucket" {
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "test-task-account-1-tfstate"
  ignore_public_acls      = true
  restrict_public_buckets = true
  source                  = "terraform-aws-modules/s3-bucket/aws"
  versioning = {
    enabled = true
  }
}
