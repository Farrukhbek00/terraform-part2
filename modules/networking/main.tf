resource "aws_vpc" "VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "database" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "database"
  }
}

# Add internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "igw"
  }
}

# Public routes
resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-crt"
  }
}
resource "aws_route_table_association" "crta-public-subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-crt.id
}

# Private routes
resource "aws_route_table" "private-crt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-nat-gateway.id
  }

  tags = {
    Name = "private-crt"
  }
}

# Database routes
resource "aws_route_table" "database-crt" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-nat-gateway.id
  }

  tags = {
    Name = "database-crt"
  }
}

resource "aws_route_table_association" "crta-private-subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-crt.id
}

resource "aws_route_table_association" "crta-database-subnet" {
  subnet_id      = aws_subnet.database.id
  route_table_id = aws_route_table.database-crt.id
}

# NAT Gateway
resource "aws_eip" "nat_gateway_public" {
  vpc = true
}

resource "aws_nat_gateway" "public-nat-gateway" {
  allocation_id = aws_eip.nat_gateway_public.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "Nat Gateway in public subnet"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_gateway_private" {
  vpc = true
}

resource "aws_nat_gateway" "private-nat-gateway" {
  allocation_id = aws_eip.nat_gateway_private.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "Nat Gateway in private subnet"
  }

  depends_on = [aws_internet_gateway.igw]
}


