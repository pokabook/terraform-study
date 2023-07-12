module "iam_assumable_role_alb_controller" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.0.0"

  create_role = true
  role_name = "${var.cluster_name}-alb-controller"
  role_description = "Used by AWS Load Balancer Controller for EKS"
  provider_url = var.oidc_issuer_url
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}

resource "aws_iam_role_policy" "controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  policy      = data.aws_iam_policy_document.aws_lb.json
  role        = module.iam_assumable_role_alb_controller.iam_role_name
}
