terraform {
  backend "s3" {
    bucket = "poka-terraform-state"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "poka-terraform"
    encrypt = true
  }
}