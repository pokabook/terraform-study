output "first_arn" {
  description = "The ARN for first user"
  value = aws_iam_user.example[0].arn
}

output "all_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}