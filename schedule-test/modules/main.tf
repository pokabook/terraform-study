resource "aws_lambda_function" "processing_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${local.name_prefix}-lambda"
  handler          = "index.handler"
  role             = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs18.x"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.name_prefix}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name = "every_5_minutes_rule"
  description = "trigger lambda every 5 min"

  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  arn  = aws_lambda_function.processing_lambda.arn
  rule = aws_cloudwatch_event_rule.every_5_minutes.name
  target_id = "SendToLambda"
}

resource "aws_lambda_permission" "allow_eventbrdige" {
  statement_id = "AllowExecutionfroEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processing_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.every_5_minutes.arn
}
