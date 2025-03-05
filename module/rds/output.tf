output "subnet_group" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.subnet_group.name

}
