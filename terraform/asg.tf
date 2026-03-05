
resource "aws_autoscaling_group" "web_asg" {
  name                = "cloud-lab-web-asg"
  desired_capacity    = 0
  min_size            = 0
  max_size            = 2

  vpc_zone_identifier = [
  aws_subnet.public_a.id,
  aws_subnet.public_b.id
]

  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cloud-lab-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "cloud-transition-lab"
    propagate_at_launch = true
  }
}



