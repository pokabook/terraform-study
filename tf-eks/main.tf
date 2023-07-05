module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "${var.name}-vpc"
  azs      = slice(data.aws_availability_zones.zones.names, 0, 3)
}


module "eks" {
  source          = "./modules/eks-cluster"
  cluster_name    = "${var.name}-cluster"
  cluster_version = "1.24"
  vpc_id          = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids
}

module "karpenter" {
  source                  = "./modules/karpenter"
  cluster_name            = module.eks.cluster_name
  node_group_iam_role_arn = module.eks.node_group_iam_role_arn
  oidc_provider_arn       = module.eks.oidc_provider_arn
}

module "csi-driver" {
  source        = "./modules/csi-driver"
  oidc_provider = module.eks.oidc_provider
}




