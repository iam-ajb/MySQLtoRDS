#VPC
resource "aws_vpc" "migration_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
#PubSub
resource "aws_subnet" "public_subnet" {

  vpc_id                  = aws_vpc.migration_vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-pub-sub-dbserver"
  }
}
#Private Subnet
resource "aws_subnet" "db_private_subnet" {
  vpc_id            = aws_vpc.migration_vpc.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.vpc_name}-private-sub-dbserver"
  }
}
resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.migration_vpc.id

  tags = {
    Name = "dbserver"
  }
}
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.migration_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}
resource "aws_route_table_association" "public" {
  count     = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)

  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.migration_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.db_private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
