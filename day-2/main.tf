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

resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "routeassociation" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.route-table-igw.id
}


resource "aws_security_group" "web-sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "allow port 22 and 80"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow port 22"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "allow port 22 and 80"
  }
}

resource "aws_instance" "webserver" {
  ami             = "ami-0b0dcb5067f052a63"
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.publicsubnet.id
  security_groups = [aws_security_group.web-sg.id]
  tags = {
    "Name" = var.instance_name
  }
}
