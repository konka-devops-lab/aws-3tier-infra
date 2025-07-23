resource "aws_cloudfront_distribution" "s3_distribution" {

    origin {
      domain_name = var.domain_name
      origin_id = var.origin_id
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations        = []
        }
}

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  default_cache_behavior {
    target_origin_id       = "albOrigin"
    viewer_protocol_policy = "redirect-http-to-https"
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
  }

    aliases = var.aliases
    enabled = var.enabled
    default_root_object = var.default_root_object

}

resource "aws_cloudfront_distribution_invalidation" "this" {
  distribution_id = aws_cloudfront_distribution.this.id
  paths           = var.invalidation_paths
}