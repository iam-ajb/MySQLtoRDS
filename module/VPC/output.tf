output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.migration_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.db_private_subnet[*].id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.db_igw.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}
