resource "aws_instance" "public_web" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 (Free Tier)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.public_web_sg.id]
  associate_public_ip_address = true

key_name = "cloud-lab-key"

iam_instance_profile = aws_iam_instance_profile.ssm_profile.name


user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "Welcome to Brent Cloud Lab Day 8 (ALB Working)" > /var/www/html/index.html
EOF

  tags = {
    Name    = "cloud-lab-public-ec2"
    Project = "cloud-transition-lab"
  }

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }
}
