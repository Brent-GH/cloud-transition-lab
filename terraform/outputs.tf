output "s3_bucket_name" {
  description = "Name of the lab S3 bucket"
  value       = aws_s3_bucket.lab_bucket.id
}

output "aws_region" {
  description = "AWS region used for this lab"
  value       = "us-east-1"
}
