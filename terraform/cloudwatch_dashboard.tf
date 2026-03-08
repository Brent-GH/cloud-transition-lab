# =============================================================
# cloudwatch_dashboard.tf
# Day 13 — CloudWatch Dashboard and Application Log Group
# =============================================================

# -------------------------------------------------------------
# DATA SOURCES
# These don't create anything — they READ existing resources
# so we can reference their IDs inside the dashboard widgets
# -------------------------------------------------------------

data "aws_lb" "existing_alb" {
  name = "cloud-lab-web-alb"
}

data "aws_instance" "public_ec2" {
  filter {
    name   = "tag:Name"
    values = ["cloud-lab-public-ec2"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running", "stopped"]
  }
}

data "aws_instance" "private_ec2" {
  filter {
    name   = "tag:Name"
    values = ["cloud-lab-private-ec2"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running", "stopped"]
  }
}

# -------------------------------------------------------------
# LOCAL VALUE
# The ALB arn_suffix is what CloudWatch uses as a dimension
# Example value: "app/cloud-lab-web-alb/abc1234567"
# -------------------------------------------------------------

locals {
  alb_arn_suffix = data.aws_lb.existing_alb.arn_suffix
}

# -------------------------------------------------------------
# LOG GROUP
# Stores application logs from your EC2 instances
# 7 day retention keeps costs low in a dev environment
# -------------------------------------------------------------

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/cloud-lab/app-logs"
  retention_in_days = 7

  tags = {
    Name      = "cloud-lab-app-logs"
    ManagedBy = "terraform"
  }
}

# -------------------------------------------------------------
# DASHBOARD
# jsonencode() converts HCL into valid JSON automatically
# Grid is 24 columns wide — widgets use x, y, width, height
# -------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "cloud-lab-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # Widget 1 — ALB Request Count (top left)
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB — Request Count"
          region = "us-east-1"
          view   = "timeSeries"
          metrics = [[
            "AWS/ApplicationELB", "RequestCount",
            "LoadBalancer", local.alb_arn_suffix,
            { stat = "Sum", period = 60 }
          ]]
        }
      },

      # Widget 2 — ALB Response Time (top right)
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB — Target Response Time (s)"
          region = "us-east-1"
          view   = "timeSeries"
          metrics = [[
            "AWS/ApplicationELB", "TargetResponseTime",
            "LoadBalancer", local.alb_arn_suffix,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      # Widget 3 — EC2 CPU Public (middle left)
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "EC2 CPU — cloud-lab-public-ec2"
          region = "us-east-1"
          view   = "timeSeries"
          metrics = [[
            "AWS/EC2", "CPUUtilization",
            "InstanceId", data.aws_instance.public_ec2.id,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      # Widget 4 — EC2 CPU Private (middle right)
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "EC2 CPU — cloud-lab-private-ec2"
          region = "us-east-1"
          view   = "timeSeries"
          metrics = [[
            "AWS/EC2", "CPUUtilization",
            "InstanceId", data.aws_instance.private_ec2.id,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      # Widget 5 — ASG Instances In Service (full width bottom)
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 24
        height = 6
        properties = {
          title  = "ASG — Instances In Service"
          region = "us-east-1"
          view   = "timeSeries"
          metrics = [[
            "AWS/AutoScaling", "GroupInServiceInstances",
            "AutoScalingGroupName", "cloud-lab-web-asg",
            { stat = "Average", period = 60 }
          ]]
        }
      }

    ]
  })
}

