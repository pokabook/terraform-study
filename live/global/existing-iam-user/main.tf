terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_user" "existing_user" {
  count = 3
  name = "tf-poka.${count.index}"
}