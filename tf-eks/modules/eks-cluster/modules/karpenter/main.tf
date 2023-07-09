module "karpenter" {
  source                          = "terraform-aws-modules/eks/aws//modules/karpenter"
  version                         = "18.31.0"
  cluster_name                    = var.cluster_name
  irsa_oidc_provider_arn          = var.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]
  create_iam_role                 = false
  iam_role_arn                    = var.node_group_iam_role_arn
}

resource "helm_release" "karpenter" {
  namespace = "karpenter"
  create_namespace = true

  name  = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = var.aws_ecrpublic_authorization_token_user_name
  repository_password = var.aws_ecrpublic_authorization_token_passwprd
  chart               = "karpenter"
  version             = "v0.20.0"

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = module.karpenter.queue_name
  }
}