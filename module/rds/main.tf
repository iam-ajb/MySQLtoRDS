# Security group
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "rds-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds-sg"
  }
}
#Ingress rule for db
resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.security_group_id
}
#egress rule 
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
#DB subnet group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "db_grp"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "db_subnet_group"
  }
}
# DB instance
resource "aws_db_instance" "rds" {
  identifier             = "ec2tords"
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  tags = {
    Name = "rds"
  }
}

