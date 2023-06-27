module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "${var.name}-vpc"
  azs      = slice(data.aws_availability_zones.zones.names, 0, 3)
}

module "iam" {
  source = "./modules/iam"
  name   = var.name
}

module "eks" {
  source          = "./modules/eks-cluster"
  cluster_name    = "${var.name}-cluster"
  cluster_version = "1.24"
  vpc_id          = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids

  userarn  = module.iam.userarn
  username = module.iam.username
}
