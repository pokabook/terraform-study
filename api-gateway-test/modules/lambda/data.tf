data "aws_iam_policy_document" "lambda_exec_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
