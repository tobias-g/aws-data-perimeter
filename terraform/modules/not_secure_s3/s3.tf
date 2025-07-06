# Here we create a simple S3 bucket with a really bad bucket policy allowing any
# other AWS account access to the objects within. This is part of a demo for AWS
# data perimeter

resource "aws_s3_bucket" "misconfigured" {
  bucket        = "${var.environment}-not-very-secure"
  force_destroy = true

  tags = {
    Name        = "${var.environment}-not-very-secure"
    Description = "Our ${var.environment} bucket with a bad bucket policy to demo aws data perimeter"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.misconfigured.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.misconfigured.id
  key    = "${var.environment}-data.txt"
  source = "${path.module}/data.txt"
  etag   = filemd5("${path.module}/data.txt")
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.misconfigured.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.allow_access_from_any_account.json,
    data.aws_iam_policy_document.block_access_from_outside_org.json, # comment out this line to make the bucket non-compliant and insecure
  ]
}

data "aws_iam_policy_document" "allow_access_from_any_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
    ]

    resources = [
      aws_s3_bucket.misconfigured.arn,
      "${aws_s3_bucket.misconfigured.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "block_access_from_outside_org" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.misconfigured.arn,
      "${aws_s3_bucket.misconfigured.arn}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalOrgID"

      values = [
        data.aws_organizations_organization.current.id,
      ]
    }
  }
}
