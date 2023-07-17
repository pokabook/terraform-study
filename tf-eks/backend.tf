terraform {
  backend "s3" {
    bucket = "poka-terraform-eks"
    key    = "poka-eks/v3/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
