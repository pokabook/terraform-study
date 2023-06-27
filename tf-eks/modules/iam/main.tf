resource "aws_iam_user" "eks_iam_user" {
  name = "${var.name}-iam"
}

resource "aws_iam_user_policy" "eks_iam_user_policy" {
  name   = "${name}-policy"
  user   = aws_iam_user.eks_iam_user.name
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": "*"
            }
        ]
    }
  EOF
}
