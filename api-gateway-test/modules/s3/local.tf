locals {
  source = var.output_path
  etag   = filemd5(var.output_path)
}
