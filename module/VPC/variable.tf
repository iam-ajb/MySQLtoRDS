variable "region_name" {
  type    = string
  default = "us-east-1"

}

variable "vpc_cidr" {

  type = string

}
variable "vpc_name" {
  type = string

}
variable "public_subnet_cidrs" {
  type = list(string)


}
variable "availability_zones" {
  type = list(string)


}
variable "private_subnet_cidrs" {
  type = list(string)

}



