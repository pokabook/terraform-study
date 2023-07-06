data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "${path.module}/src/index.js"
  output_file_mode = "0666"
  output_path = "${path.module}/bin/index.js.zip"
}
