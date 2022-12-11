---
title: module in terraform
author: haimtran
description: module in terraform
publishedDate: 11/12/2022
---

## Introduction

this is day 3 and will show

- modules
- variables
- setup

## Project Structure

```
--day3
  |--setup
     |--main.tf
  |--modules
     |--webserver
        |--main.tf
        |--variables.tf
```

## Modules

variables in variables.tf

```js
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

```

then main.tf which use variables from the variable.tf

```js
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0.0"
    }
  }
}

resource "aws_subnet" "webserver" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
}

resource "aws_route_table_association" "routeassociation" {
  subnet_id      = aws_subnet.webserver.id
  route_table_id = var.route_table_id
}

resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.webserver.id
  tags = {
    "Name" : "${var.webserver_name}"
  }
}
```

## Setup

terraform versions and providers

```js
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

```

create a vpc, internet gateway and route table

```js
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
```

then create a webserver as following

```js
module "webserver" {
  source            = "../modules/webserver"
  vpc_id            = aws_vpc.vpc.id
  subnet_cidr_block = "10.0.1.0/24"
  webserver_name    = "haimtran"
  ami               = "ami-0b0dcb5067f052a63"
  instance_type     = "t2.medium"
  route_table_id    = aws_route_table.route-table-igw.id
}
```
