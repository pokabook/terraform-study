resource "aws_apigatewayv2_api" "lambda_apigv2" {
  name          = "${var.apigv2_name_prefix}-apigv2"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda_apigv2_stage" {
  api_id = aws_apigatewayv2_api.lambda_apigv2.id

  name        = "${var.apigv2_name_prefix}-apigv2-stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_apigatewayv2_integration" "lambda_apigv2_integration" {
  for_each = var.api_information
  api_id             = aws_apigatewayv2_api.lambda_apigv2.id

  integration_uri    = each.value.lambda_invoke_arn
  integration_type   = each.value.integration_type
  integration_method = each.value.integration_method
}

resource "aws_apigatewayv2_route" "lambda_apigv2_route" {
  for_each = local.route_keys

  api_id    = aws_apigatewayv2_api.lambda_apigv2.id

  route_key = each.value
  target = "integrations/${aws_apigatewayv2_integration.lambda_apigv2_integration[each.key].id}"

}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_apigv2.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  for_each = var.api_information
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_apigv2.execution_arn}/*/*"
}
