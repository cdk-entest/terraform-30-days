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
