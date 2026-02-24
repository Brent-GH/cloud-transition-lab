# Public subnets (2 AZs)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-a"
    Project = "cloud-transition-lab"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-b"
    Project = "cloud-transition-lab"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name    = "lab-igw"
    Project = "cloud-transition-lab"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name    = "public-rt"
    Project = "cloud-transition-lab"
  }
}

# Route: all IPv4 internet traffic to IGW
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
