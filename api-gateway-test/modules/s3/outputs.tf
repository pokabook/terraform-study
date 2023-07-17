output "bucket_id" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "bucket_key" {
  value = aws_s3_object.lambda.key
}
