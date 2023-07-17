resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "${var.bucket_name_prefix}-bucket"

  force_destroy = true
}

resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = var.bucket_key
  source = local.source

  etag   = local.etag
}
