import {
  source = "/modules/s3-bucket/bucket.tm.hcl"
}

globals {
  use_remote_state = false
  s3_bucket_name   = "${global.s3_tfstate_bucket}"
}
