---
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

```tf


```
