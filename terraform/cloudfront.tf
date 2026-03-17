# =============================================================
# cloudfront.tf
# Day 14 — CloudFront CDN distribution
# =============================================================

# -------------------------------------------------------------
# ORIGIN ACCESS CONTROL (OAC)
# Modern replacement for the older Origin Access Identity
# This is what allows CloudFront to read from private S3
# signing_behavior = "always" means every request is signed
# -------------------------------------------------------------

resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "cloud-lab-website-oac"
  description                       = "OAC for cloud-lab static website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# -------------------------------------------------------------
# CLOUDFRONT DISTRIBUTION
# price_class PriceClass_100 = US and Europe edge only
# This is the cheapest option — fine for a lab
# default_root_object = what to serve when hitting "/"
# -------------------------------------------------------------

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  default_root_object = "index.html"
  comment             = "cloud-lab static website distribution"
  price_class         = "PriceClass_100"

  # --- Where CloudFront fetches content from ---
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-cloud-lab-website"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # --- How CloudFront handles incoming requests ---
  default_cache_behavior {
    target_origin_id       = "S3-cloud-lab-website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Cache content for 1 hour by default
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # --- No geo restrictions for this lab ---
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # --- HTTPS using the default CloudFront certificate ---
  # Free — no need to provision your own SSL cert
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name      = "cloud-lab-cloudfront"
    ManagedBy = "terraform"
  }
}

