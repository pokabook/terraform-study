module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  enable_irsa = true

  node_security_group_additional_rules = {
    ingress_nodes_karpenter_port = {
      description                   = "Cluster API to Node group for Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }

  eks_managed_node_groups = {
    initial = {
      instance_types         = ["t3.large"]
      create_security_group  = false
      create_launch_template = false
      launch_template_name   = ""

      min_size     = 2
      max_size     = 3
      desired_size = 2

      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = "tf-iam"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

resource "aws_ec2_tag" "private_subnet_tag" {
  count       = length(local.private_subnets)
  resource_id = local.private_subnets[count.index]
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  count       = length(local.private_subnets)
  resource_id = local.private_subnets[count.index]
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "private_subnet_karpenter_tag" {
  count       = length(local.private_subnets)
  resource_id = local.private_subnets[count.index]
  key         = "karpenter.sh/discovery/${local.cluster_name}"
  value       = local.cluster_name
}

resource "aws_ec2_tag" "public_subnet_tag" {
  count       = length(local.public_subnets)
  resource_id = local.private_subnets[count.index]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}