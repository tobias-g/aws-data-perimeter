resource "aws_s3_bucket" "config_recorder" {
  bucket        = "aws-config-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name        = "aws-config-${data.aws_caller_identity.current.account_id}"
    Description = "Bucket to use as an AWS Config delivery channel"
  }
}