resource "aws_ecr_repository" "test" {
  name                 = "${var.name_prefix}-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_lifecycle_policy" "test-policy" {
  repository = aws_ecr_repository.test.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.image_limit} images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.tag_prefix_list
          countType     = "imageCountMoreThan"
          countNumber   = var.image_limit
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

}

resource "null_resource" "ecr_get_login_password" {
  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.test.repository_url}
    EOF
  }
}
