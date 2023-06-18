locals {
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  region           = "ap-northeast-2"
  vpc_id           = var.vpc_id
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  current_username = element(split("/", data.aws_caller_identity.current.arn), 1)
  tag = {
    Environment = "test"
    Terraform   = "true"
  }
}