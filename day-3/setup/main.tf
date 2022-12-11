terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route-table-igw" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


module "webserver" {
  source            = "../modules/webserver"
  vpc_id            = aws_vpc.vpc.id
  subnet_cidr_block = "10.0.1.0/24"
  webserver_name    = "haimtran"
  ami               = "ami-0b0dcb5067f052a63"
  instance_type     = "t2.medium"
  route_table_id    = aws_route_table.route-table-igw.id
}


