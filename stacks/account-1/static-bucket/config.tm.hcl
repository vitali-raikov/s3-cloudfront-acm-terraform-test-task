import {
  source = "/modules/s3-bucket/bucket.tm.hcl"
}

globals {
  # We override normal bucket name here
  s3_bucket_name = global.domain_name
}

##############################################################################
# Generate terraform files in each stack
# All globals will be replaced with the final value that is known by the stack
# Any terraform code can be defined within the content block

generate_hcl "_generated_bucket_file.tf" {
  content {
    resource "aws_s3_object" "index" {
      bucket       = tm_hcl_expression("module.s3_bucket.s3_bucket_id")
      key          = "index.html"
      content_type = "text/html"
      source       = "files/index.html"
    }
  }
}
