resource "aws_cloudfront_origin_access_control" "mirror" {
  name                              = var.domain
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_response_headers_policy" "security" {
  name = "Managed-SecurityHeadersPolicy"
}

data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "disabled" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_distribution" "mirror" {
  enabled         = true
  is_ipv6_enabled = true
  aliases         = [var.domain]
  http_version    = "http2and3"

  origin {
    domain_name              = aws_s3_bucket.mirror.bucket_regional_domain_name
    origin_id                = "s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.mirror.id
  }

  default_cache_behavior {
    target_origin_id           = "s3"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.optimized.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security.id
  }

  # package files are immutable once published; the repository database
  # mutates on every publish and must never be served stale
  ordered_cache_behavior {
    path_pattern               = "/x86_64/axr.db*"
    target_origin_id           = "s3"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.disabled.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security.id
  }

  ordered_cache_behavior {
    path_pattern               = "/axr-keyring*"
    target_origin_id           = "s3"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.disabled.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security.id
  }

  ordered_cache_behavior {
    path_pattern               = "/x86_64/axr.files*"
    target_origin_id           = "s3"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.disabled.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security.id
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.mirror.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
