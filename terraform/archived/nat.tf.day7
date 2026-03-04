resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name    = "cloud-lab-nat-eip"
    Project = "cloud-transition-lab"
  }
}

resource "aws_nat_gateway" "lab_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = "subnet-0864ad793351bfe7d"

  tags = {
    Name    = "cloud-lab-nat"
    Project = "cloud-transition-lab"
  }

  depends_on = [aws_internet_gateway.igw]
}
