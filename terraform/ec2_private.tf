resource "aws_instance" "private_app" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t3.micro" 
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.public_web_sg.id]
  associate_public_ip_address = false

  tags = {
    Name    = "cloud-lab-private-ec2"
    Project = "cloud-transition-lab"
  }
}
