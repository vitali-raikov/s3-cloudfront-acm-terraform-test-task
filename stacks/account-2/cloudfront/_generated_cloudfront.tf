// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "aws_cloudfront_origin_access_control" "this" {
  description                       = "Cloudfront origin access control for access to S3 bucket"
  name                              = "bolt.crabdance.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
resource "aws_cloudfront_origin_access_identity" "restrict_direct_access" {
  comment = "Restrict access to S3 bucket only from Cloudfront"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  aliases = [
    "bolt.crabdance.com",
  ]
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  origin {
    domain_name              = "bolt.crabdance.com.s3.eu-north-1.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = "bolt.crabdance.com"
  }
  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 0
    target_origin_id       = "bolt.crabdance.com"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  restrictions {
    geo_restriction {
      locations = [
      ]
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
