variable "apigv2_name_prefix" {
}

variable "api_information" {
  type = map(object({
    lambda_invoke_arn  = string
    integration_method = string
    integration_type   = string
    http_method        = string
    uri                = string
    function_name      = string
  }))
}
