terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}
