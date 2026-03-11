# =============================================================
# rds.tf
# Day 15 — RDS MySQL database in private subnets
# =============================================================

# -------------------------------------------------------------
# DB SUBNET GROUP
# Tells RDS which subnets it can use
# Must span at least 2 AZs — we use both private subnets
# -------------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name        = "cloud-lab-db-subnet-group"
  description = "Private subnets for RDS"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name      = "cloud-lab-db-subnet-group"
    ManagedBy = "terraform"
  }
}

# -------------------------------------------------------------
# DB PARAMETER GROUP
# Controls database engine settings
# Using mysql8.0 family — matches the engine version below
# -------------------------------------------------------------

resource "aws_db_parameter_group" "main" {
  name        = "cloud-lab-db-params"
  family      = "mysql8.0"
  description = "Parameter group for cloud-lab MySQL"

  tags = {
    Name      = "cloud-lab-db-params"
    ManagedBy = "terraform"
  }
}

# -------------------------------------------------------------
# RDS INSTANCE
# db.t3.micro = free tier eligible
# multi_az = false keeps cost down for a lab
# skip_final_snapshot = true so we can destroy cleanly
# storage_encrypted = true — always encrypt data at rest
# -------------------------------------------------------------

resource "aws_db_instance" "main" {
  identifier = "cloud-lab-db"

  # Engine
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  # Storage
  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp2"
  storage_encrypted     = true

  # Database credentials
  db_name  = "cloudlab"
  username = "admin"
  password = "CloudLab2024Secure"

  # Network — private subnets, no public access
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  # Configuration
  parameter_group_name = aws_db_parameter_group.main.name
  multi_az             = false

  # Backups
  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Deletion settings — safe for a lab environment
  skip_final_snapshot      = true
  delete_automated_backups = true
  deletion_protection      = false

  tags = {
    Name      = "cloud-lab-db"
    ManagedBy = "terraform"
  }
}
