
resource "aws_launch_template" "web_template" {

  name_prefix   = "cloud-lab-web-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  key_name = "cloud-lab-key"

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.public_web_sg.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Welcome to Brent Cloud Lab Auto Scaling Server" > /var/www/html/index.html
EOF
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "cloud-lab-asg-instance"
      Project = "cloud-transition-lab"
    }
  }
}
