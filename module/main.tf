module "vpc" {
  source               = "./VPC" # Change the path if using a remote module
  vpc_name             = "my-vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "ec2_private" {
  vpc_id        = module.vpc.vpc_id
  source        = "./EC2" # Local module path for EC2
  ami_id        = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_ids[0] # Picks first private subnet

}

