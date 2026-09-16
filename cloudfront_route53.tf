# 1. CloudFront Distribution
resource "aws_cloudfront_distribution" "web_cdn" {
  enabled = true
  comment = "Global CDN for Portfolio Website"

  # The Origin is our Application Load Balancer
  origin {
    domain_name = aws_lb.web_alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port  = 80
      https_port = 443
      # We use HTTP-only to the origin since we don't have an SSL cert on the ALB
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # We use the default CloudFront SSL certificate for testing
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = { Name = "web-cdn" }
}

# 2. Route 53 Hosted Zone (Placeholder for IaC completeness)
resource "aws_route53_zone" "portfolio_zone" {
  name = "arfaan-portfolio.local"
}

# 3. Route 53 Alias Record pointing to CloudFront
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.portfolio_zone.zone_id
  name    = "www.arfaan-portfolio.local"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.web_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.web_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# 4. Output values so we know exactly where to view the website after deployment
output "alb_dns_name" {
  description = "The DNS name of the ALB directly"
  value       = aws_lb.web_alb.dns_name
}

output "cloudfront_domain_name" {
  description = "The global CloudFront domain name to access the website"
  value       = aws_cloudfront_distribution.web_cdn.domain_name
}