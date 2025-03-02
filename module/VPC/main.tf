
resource "aws_vpc" "db_server_vpc" {
  cidr_block         = "10.0.0.0/22"
  enable_dns_support = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.db_server_vpc.id
  cidr_block              = "10.0.1.0/25"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-dbserver"
  }
}

resource "aws_subnet" "db_private_subnet" {
  vpc_id     = aws_vpc.db_server_vpc.id
  cidr_block = "10.0.1.128/25"

  tags = {
    Name = "dbserver"
  }
}
resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.db_server_vpc.id

  tags = {
    Name = "dbserver"
  }
}
resource "aws_route_table" "dbroute" {
  vpc_id = aws_vpc.db_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
  }
  tags = {
    Name = "dbserver"
  }
}
resource "aws_route_table_association" "db_server_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.dbroute.id
}
