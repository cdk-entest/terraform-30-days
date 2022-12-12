## Backend S3

create a bucket and configure in main.tf

```js
terraform {
  backend "s3" {
    bucket = "terraform-backend-090688"
    key    = "terraform/"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0.0"
    }
  }
}

```

then command, assume no state at this moment

```bash
terraform apply
```

wait for the statefile uploaded in the s3 bucket and there is not statefile stored in local.

## Provisioner

this is similar to EC2 UserData which means we can provide commands, data to EC2 or other compute resources. Here, echo command will run from the local machine, and the content will be upload to the EC2 in AWS.

```js
resource "aws_instance" "webserver" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.publicsubnet.id
  tags = {
    "Name" = "webserver"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

  provisioner "file" {
    content     = "hello haitran"
    destination = "/home/ec2-user/"
  }
}
```
