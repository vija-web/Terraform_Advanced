# CloudFront distribution with ALB origin
resource "aws_cloudfront_distribution" "roboshop" {
  enabled             = true
  price_class         = "PriceClass_All"  # All edge locations

  aliases = ["${var.environment}.vijayaws.fun"]

  # The ALB as the origin
  origin {
    domain_name = "${var.project}-${var.environment}.vijayaws.fun"
    origin_id   = "${var.project}-${var.environment}.vijayaws.fun"

    custom_origin_config {
      http_port = 80
      https_port             = 443
      origin_protocol_policy = "https-only"  # Always use HTTPS to the ALB
      origin_ssl_protocols   = ["TLSv1.2"]

      # Timeouts - increase for slow APIs
      origin_read_timeout    = 60
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.environment}.vijayaws.fun"


    viewer_protocol_policy = "https-only"
    cache_policy_id  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.environment}.vijayaws.fun"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "https-only"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.environment}.vijayaws.fun"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "https-only"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

   restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "IN", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_ssm_parameter.roboshop-certificate.value
    ssl_support_method  = "sni-only"
  }

}

resource "aws_route53_record" "cloudfront" {
  zone_id  = data.aws_route53_zone.selected.zone_id
  name     = "${var.environment}"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = false
  }
}