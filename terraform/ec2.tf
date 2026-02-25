resource "aws_instance" "public_web" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 (Free Tier)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.public_web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name    = "cloud-lab-public-ec2"
    Project = "cloud-transition-lab"
  }
}
