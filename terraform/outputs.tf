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
