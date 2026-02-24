resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "lab-vpc"
    Project = "cloud-transition-lab"
  }
}
