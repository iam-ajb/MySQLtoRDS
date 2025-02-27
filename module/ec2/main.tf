resource "aws_instance" "db_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = ""

  tags = {
    Name = "dbserver"
  }
}
resource "aws_vpc" "db_server_vpc" {
  cidr_block = "13.0.0.0/28"
}
