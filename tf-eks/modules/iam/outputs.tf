output "userarn" {
  value = aws_iam_user.eks_iam_user.arn
}

output "username" {
  value = aws_iam_user.eks_iam_user.name
}
