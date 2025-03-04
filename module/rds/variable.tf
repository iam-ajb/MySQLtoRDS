variable "allocated_storage" {
  type = string

}
variable "db_name" {
  type = string
}
variable "db_engine" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "username" {
  type = string
}
variable "password" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "ec2_sg" {
  type = string
}
variable "subnet_ids" {
  type = list(string)

}
variable "security_group_id" {
  type = string

}
variable "db_subnet_group_name" {
  type = string

}
