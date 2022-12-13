// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  backend "s3" {
    bucket  = "test-task-account-1-tfstate"
    key     = "stacks/account-1/static-bucket/terraform.tfstate"
    profile = "bolt-account-1"
    region  = "eu-north-1"
  }
}
