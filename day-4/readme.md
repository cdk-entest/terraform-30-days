## Different Workspace

```bash
terraform workspace list
```

create a dev workspace

```bash
terraform workspace new prod
```

create a prod workspace

```bash
terraform workspace new dev
```

## Pass Variables

it is possible to access workspace in main.tf as

```js
locals {
  instance_name = "${terraform.workspace}-instance"
}
```

var.instance_type are different for dev and prod environments (workspace), and passed from dev.tfvars and prod.tfvars.

```js
resource "aws_instance" "webserver" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.publicsubnet.id
  tags = {
    "Name" = local.instance_name
  }
}
```

create variables.tf

```js
variable "instance_type" {
  type = string
}
```

create dev.tfvars

```js
instance_type = "t2.medium";
```

create prod.tfvars

```js
instance_type = "t3.medium";
```

then pass variables

```bash
terraform apply -var-file=def.tfvars
```

## Deploy

```bash
terraform init
```

and the apply

```bash
terraform apply -var-file dev.tfvars
```

and

```bash
terraform apply -var-file prod.tfvars
```
