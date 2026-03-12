# =============================================================
# modules/monitoring/main.tf
# CloudWatch dashboard and log group as a reusable module
# =============================================================

# -------------------------------------------------------------
# LOG GROUP
# -------------------------------------------------------------

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/cloud-lab/app-logs"
  retention_in_days = var.log_retention_days

  tags = {
    Name      = "cloud-lab-app-logs"
    ManagedBy = "terraform"
  }
}

# -------------------------------------------------------------
# DASHBOARD
# All metric dimensions come from input variables
# This makes the module reusable across environments
# -------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "cloud-lab-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB — Request Count"
          region = var.aws_region
          view   = "timeSeries"
          metrics = [[
            "AWS/ApplicationELB", "RequestCount",
            "LoadBalancer", var.alb_arn_suffix,
            { stat = "Sum", period = 60 }
          ]]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "ALB — Target Response Time (s)"
          region = var.aws_region
          view   = "timeSeries"
          metrics = [[
            "AWS/ApplicationELB", "TargetResponseTime",
            "LoadBalancer", var.alb_arn_suffix,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "EC2 CPU — cloud-lab-public-ec2"
          region = var.aws_region
          view   = "timeSeries"
          metrics = [[
            "AWS/EC2", "CPUUtilization",
            "InstanceId", var.public_instance_id,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title  = "EC2 CPU — cloud-lab-private-ec2"
          region = var.aws_region
          view   = "timeSeries"
          metrics = [[
            "AWS/EC2", "CPUUtilization",
            "InstanceId", var.private_instance_id,
            { stat = "Average", period = 60 }
          ]]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 24
        height = 6
        properties = {
          title  = "ASG — Instances In Service"
          region = var.aws_region
          view   = "timeSeries"
          metrics = [[
            "AWS/AutoScaling", "GroupInServiceInstances",
            "AutoScalingGroupName", var.asg_name,
            { stat = "Average", period = 60 }
          ]]
        }
      }

    ]
  })
}

