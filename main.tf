module "vpc" {
  source               = "./module/VPC" # Change the path if using a remote module
  vpc_name             = "my-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "ec2_private" {
  vpc_id        = module.vpc.vpc_id
  source        = "./module/ec2" # Local module path for EC2
  ami_id        = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_ids[0] # Picks first private subnet

}
module "secret" {
  source   = "./module/secrets" # Local module path for EC2
  password = var.password
}
module "db_instance" {
  vpc_id               = module.vpc.vpc_id
  source               = "./module/rds" # Local module path for EC2
  allocated_storage    = 20
  db_name              = "mydatabase"
  db_engine            = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "dbuser"
  password             = module.secret.db_password
  ec2_sg               = module.ec2_private.ec2_sg
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_id    = module.ec2_private.ec2_sg
  db_subnet_group_name = module.vpc.private_subnet_ids
}
