terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "asg" {
  source = "../../modules/cluster/asg-rolling-deploy"

  cluster_name       = data.aws_ami.ubuntu.id

  enable_autoscaling = false

  ami                = data.aws_ami.ubuntu.id
  instance_type      = "t2.micro"

  max_size           = 1
  min_size           = 1

  subnet_ids        = data.aws_subnets.default.ids
}