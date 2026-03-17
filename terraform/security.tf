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
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
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
# =============================================================
# RDS Security Group — Day 15
# Allows MySQL port 3306 from EC2 instances only
# No internet access to the database
# =============================================================

resource "aws_security_group" "rds_sg" {
  name        = "cloud-lab-rds-sg"
  description = "Allow MySQL from EC2 instances only"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_web_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "cloud-lab-rds-sg"
    ManagedBy = "terraform"
  }
}

