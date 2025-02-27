
resource "aws_vpc" "db_server_vpc" {
  cidr_block         = "13.0.0.0/28"
  enable_dns_support = true
}

resource "aws_subnet" "db_server_subnet" {
  vpc_id     = aws_vpc.db_server_vpc.id
  cidr_block = "13.0.0.0/28"

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
  subnet_id      = aws_subnet.db_server_subnet.id
  route_table_id = aws_route_table.dbroute.id
}
resource "aws_security_group" "allow_tls" {
  name        = "db-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.db_server_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_allow_tls"
  }
}
