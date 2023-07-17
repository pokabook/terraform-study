output "base_url" {
  value = aws_apigatewayv2_stage.lambda_apigv2_stage.invoke_url
}
