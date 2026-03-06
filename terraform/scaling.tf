

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "cloud-lab-scale-up"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  adjustment_type     = "ChangeInCapacity"
  scaling_adjustment  = 1
  cooldown            = 60
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "cloud-lab-scale-down"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  adjustment_type     = "ChangeInCapacity"
  scaling_adjustment  = -1
  cooldown            = 60
}
