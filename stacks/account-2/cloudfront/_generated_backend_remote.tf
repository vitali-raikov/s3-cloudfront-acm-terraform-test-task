// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket  = "test-task-account-2-tfstate"
    key     = "stacks/account-2/cloudfront/terraform.tfstate"
    profile = "bolt-account-2"
    region  = "eu-north-1"
  }
}
