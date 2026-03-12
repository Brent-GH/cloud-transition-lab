# =============================================================
# modules/monitoring/variables.tf
# Inputs the monitoring module accepts from the root module
# =============================================================
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix used as CloudWatch dimension"
  type        = string
}

variable "public_instance_id" {
  description = "EC2 public instance ID"
  type        = string
}

variable "private_instance_id" {
  description = "EC2 private instance ID"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 7
}
