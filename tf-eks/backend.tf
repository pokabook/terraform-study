terraform {
  backend "s3" {
    bucket = "poka-terraform-eks"
    key    = "poka-eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}