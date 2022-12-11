terraform {
  backend "s3" {
    bucket = "terraform-backend-090688"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }

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

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_route_table_association" "routeassociation" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.route-table-igw.id
}


resource "aws_instance" "webserver" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.publicsubnet.id
  tags = {
    "Name" = "webserver"
  }
}
