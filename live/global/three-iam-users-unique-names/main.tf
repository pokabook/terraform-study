terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}