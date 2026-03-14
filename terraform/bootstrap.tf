# =============================================================
# bootstrap.tf
# Day 17 — S3 and DynamoDB for remote Terraform state
# =============================================================

# -------------------------------------------------------------
# S3 BUCKET
# Stores the terraform.tfstate file remotely
# Versioning is critical — every apply is recoverable
# Encryption protects sensitive values stored in state
# -------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  bucket = "cloud-lab-tfstate-211661224499"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name      = "cloud-lab-terraform-state"
    ManagedBy = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -------------------------------------------------------------
# DYNAMODB TABLE
# Handles state locking — prevents concurrent applies
# PAY_PER_REQUEST = no charge when not in use
# LockID is the required key name for Terraform locking
# -------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "cloud-lab-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name      = "cloud-lab-terraform-state-locks"
    ManagedBy = "terraform"
  }
}
