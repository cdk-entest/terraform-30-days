---
title: Hello Terraform
description: getting started with Terraform
author: haimtran
publishedDate: 11/21/2022
date: 2022-11-21
---

## Introduction

[Github]() this is day 1 learning terraform

- Install terraform
- Run nginx
- Create a lambda function

## Install terraform

Download the binary for linux and update the PATH

```bash
wget https://releases.hashicorp.com/terraform/1.3.4/terraform_1.3.4_linux_386.zip
```

or install from cli

```bash
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

update the PATH

```bash
export PATH=/home/ec2-user/workspace/terraform:$PATH
```

check

```bash
terraform -help
```

## Run Nginx

```tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```

then run

```bash
terraform init
```

and apply

```bash
terraform apply
```

need SSH port forwarding (either using vscode or from terminal)

```bash
ssh -L 8000:localhost:8000 ec2-user@ssm-vscode
```

then open browser from your local machine localhost:8000 and shoud see the nginx running

## Create a Lambda in Terraform

create a bucket to store the lambda source code and dependencies

```tsx
resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}
```

s3 object which store the lambda source code and dependencies

```tsx
resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}
```

create a lambda function

```tsx
resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}
```

lambda function role

```tsx
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}
```

add policy for the lambda role

```tsx
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

```

## Troubleshooting

might need to downgrade to aws 4.0.0 for compatible or check how to create a S3 in the newest aws terraform [HERE]

```tsx
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
}
```
