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
resource "aws_route_table_association" "crta-private-subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-crt.id
}

# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "public-nat-gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "Nat Gateway in public subnet"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Security Group
resource "aws_security_group" "SG-Bastion" {
  vpc_id = aws_vpc.VPC.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["84.54.78.36/32", "185.230.204.108/32"]
  }

  tags = {
    Name = "SG-Bastion"
  }
}

# Security Group
resource "aws_security_group" "SG-Private" {
  vpc_id = aws_vpc.VPC.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [aws_vpc.VPC.cidr_block]
  }

  tags = {
    Name = "SG-Private"
  }
}
