resource "random_pet" "lambda_bucket_name" {
  length = 4
}

module "s3" {
  source             = "./modules/s3"
  bucket_name_prefix = local.name_prefix
  bucket_key         = "hello-world.zip"
  output_path        = data.archive_file.lambda_hello_world.output_path
}

module "lambda" {
  source             = "./modules/lambda"
  bucket_id          = module.s3.bucket_id
  bucket_key         = module.s3.bucket_key
  lambda_name_prefix = local.name_prefix
}

module "apigv2" {
  source             = "./modules/apigv2"
  apigv2_name_prefix = local.name_prefix
  api_information = {
    "hello" = {
      lambda_invoke_arn  = module.lambda.invoke_arn
      integration_method = "POST"
      integration_type   = "AWS_PROXY"
      http_method        = "GET"
      uri                = "/hello"
      function_name      = module.lambda.function_name
    }
  }
}
