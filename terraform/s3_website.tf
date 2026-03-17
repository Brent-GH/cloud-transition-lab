# =============================================================
# s3_website.tf
# Day 14 — S3 bucket for static website content
# =============================================================

# -------------------------------------------------------------
# S3 BUCKET
# Private bucket — CloudFront accesses it via OAC
# Not publicly accessible directly
# -------------------------------------------------------------

resource "aws_s3_bucket" "website" {
  bucket = "cloud-lab-website-211661224499"

  tags = {
    Name      = "cloud-lab-website"
    ManagedBy = "terraform"
  }
}

# Block all public access — OAC handles CloudFront access
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning — lets you roll back content if needed
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -------------------------------------------------------------
# BUCKET POLICY
# Grants CloudFront OAC permission to read objects
# The CloudFront ARN reference links this to cloudfront.tf
# -------------------------------------------------------------

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# -------------------------------------------------------------
# SAMPLE INDEX PAGE
# Uploaded directly via Terraform so the site works immediately
# Replace this content later with your real static site
# -------------------------------------------------------------

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  content_type = "text/html"

  content = <<-HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Cloud Lab</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          text-align: center;
          padding: 60px;
          background: #f4f4f4;
        }
        h1   { color: #232f3e; }
        p    { color: #555; }
        .badge {
          background: #ff9900;
          color: white;
          padding: 6px 14px;
          border-radius: 4px;
        }
      </style>
    </head>
    <body>
      <h1>☁️ Cloud Lab — Static Website</h1>
      <p>Served via <span class="badge">CloudFront + S3</span></p>
      <p>Deployed with Terraform · Day 14</p>
    </body>
    </html>
  HTML
}
