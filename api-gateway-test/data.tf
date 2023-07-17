data "archive_file" "lambda_hello_world" {
  type        = "zip"

  source_dir  = "${path.module}/src"
  output_path = "${path.module}/bin/hello-world.zip"
}
