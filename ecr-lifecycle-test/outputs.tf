output "ecr_registry_id" {
  value = aws_ecr_repository.test.registry_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.test.repository_url
}
