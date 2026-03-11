output "s3_bucket_name" {
  description = "Name of the lab S3 bucket"
  value       = aws_s3_bucket.lab_bucket.id
}

output "aws_region" {
  description = "AWS region used for this lab"
  value       = "us-east-1"
}

output "vpc_id" {
  description = "VPC ID for the lab"
  value       = aws_vpc.lab_vpc.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (for internet-facing resources)"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs (for internal resources like databases)"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}
output "private_instance_id" {
  description = "EC2 instance ID (private subnet)"
  value       = aws_instance.private_app.id
}
# Day 14 outputs
output "website_bucket_name" {
  description = "S3 static website bucket name"
  value       = aws_s3_bucket.website.bucket
}

output "cloudfront_domain" {
  description = "CloudFront URL — open this in your browser to see the site"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

# Day 15 outputs
output "rds_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_database_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}
