resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "aws-config"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = false

    resource_types = [
      "AWS::S3::Bucket",
    ]

    recording_strategy {
      use_only = "INCLUSION_BY_RESOURCE_TYPES"
    }
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_config_configuration_recorder_status" "config_recorder" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}

resource "aws_config_delivery_channel" "config_channel" {
  name           = "aws-config"
  s3_bucket_name = aws_s3_bucket.config_recorder.id
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_iam_role" "config_role" {
  name               = "aws-config"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "config_role" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy" "config_policy" {
  name   = "aws-config"
  role   = aws_iam_role.config_role.id
  policy = data.aws_iam_policy_document.config_policy.json
}

data "aws_iam_policy_document" "config_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.config_recorder.id}",
      "arn:aws:s3:::${aws_s3_bucket.config_recorder.id}/*"
    ]
  }
}
