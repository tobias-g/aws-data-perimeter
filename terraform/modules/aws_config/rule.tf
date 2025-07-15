resource "aws_config_config_rule" "data_perimeter_s3" {
  name        = "data-perimeter-s3"
  description = "Checks buckets deny access from outside our AWS org"

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.data_perimeter_s3.arn

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  scope {
    compliance_resource_types = [
      "AWS::S3::Bucket",
      "AWS::S3::AccountPublicAccessBlock",
    ]
  }

  depends_on = [
    aws_lambda_permission.allow_config_s3,
  ]
}