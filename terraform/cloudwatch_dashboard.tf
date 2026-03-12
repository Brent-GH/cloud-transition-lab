# =============================================================
# cloudwatch_dashboard.tf
# Day 16 — Refactored to use monitoring module
# =============================================================

# -------------------------------------------------------------
# DATA SOURCES — stay in root, feed values into the module
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
# -------------------------------------------------------------

locals {
  alb_arn_suffix = data.aws_lb.existing_alb.arn_suffix
}

# -------------------------------------------------------------
# MODULE CALL
# Instead of defining resources here, we call the module
# and pass in the values it needs as input variables
# -------------------------------------------------------------

module "monitoring" {
  source = "./modules/monitoring"

  aws_region          = "us-east-1"
  alb_arn_suffix      = local.alb_arn_suffix
  public_instance_id  = data.aws_instance.public_ec2.id
  private_instance_id = data.aws_instance.private_ec2.id
  asg_name            = "cloud-lab-web-asg"
  log_retention_days  = 7
}
