// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${data.aws_s3_bucket.static.arn}/*",
    ]
    principals {
      identifiers = [
        "cloudfront.amazonaws.com",
      ]
      type = "Service"
    }
    condition {
      test = "StringEquals"
      values = [
        aws_cloudfront_distribution.s3_distribution.arn,
      ]
      variable = "AWS:SourceArn"
    }
  }
}
resource "aws_s3_bucket_policy" "restrict_direct_access" {
  bucket   = data.aws_s3_bucket.static.id
  policy   = data.aws_iam_policy_document.s3_policy.json
  provider = aws.account-1
}
