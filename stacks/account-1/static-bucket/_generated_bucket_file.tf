// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_s3_object" "index" {
  bucket       = module.s3_bucket.s3_bucket_id
  content_type = "text/html"
  key          = "index.html"
  source       = "files/index.html"
}
