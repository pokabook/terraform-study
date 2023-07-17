resource "aws_lambda_function" "lambda" {
  function_name = "${var.lambda_name_prefix}-function"

  s3_bucket     = var.bucket_id
  s3_key        = var.bucket_key

  runtime       = var.runtime
  handler       = var.handler

  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_name_prefix}-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_exec_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
