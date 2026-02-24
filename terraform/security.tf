# Security Group for public-facing instances (e.g., web server)

resource "aws_security_group" "public_web_sg" {
  name        = "public-web-sg"
  description = "Allow HTTP and SSH inbound"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (for lab use only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "public-web-sg"
    Project = "cloud-transition-lab"
  }
}
