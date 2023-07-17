variable "lambda_name_prefix" {
}

variable "bucket_id" {
}

variable "bucket_key" {
}

variable "runtime" {
  default = "nodejs16.x"
}

variable "handler" {
  default = "hello.handler"
}
