# Private subnets (no public IPs)

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.10.11.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-a"
    Project = "cloud-transition-lab"
    Tier    = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.10.12.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-b"
    Project = "cloud-transition-lab"
    Tier    = "private"
  }
}
