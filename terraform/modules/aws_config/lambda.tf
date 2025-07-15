data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/function/src"
  output_path = "${path.module}/source.zip"
}

resource "aws_lambda_function" "data_perimeter_s3" {
  filename         = data.archive_file.source.output_path
  function_name    = "data-perimeter-s3"
  role             = aws_iam_role.data_perimeter_lambda.arn
  handler          = "s3.handler"
  source_code_hash = data.archive_file.source.output_base64sha256
  runtime          = "nodejs20.x"

  environment {
    variables = {
      ORG_ID = data.aws_organizations_organization.current.id
    }
  }
}

resource "aws_lambda_permission" "allow_config_s3" {
  statement_id   = "AllowExecutionFromConfig"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.data_perimeter_s3.function_name
  principal      = "config.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}
