variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "subnet_cidr_block" {
  type        = string
  description = "vpc cidr block"
}

variable "ami" {
  type        = string
  description = "ami of ec2"
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}


variable "webserver_name" {
  type        = string
  description = "webserver name"
}

variable "route_table_id" {
  type        = string
  description = "route table id"
}
