resource "aws_iam_role" "data_perimeter_lambda" {
  name               = "data-perimeter-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "data_perimeter_lambda" {
  name   = "data-perimeter-lambda"
  policy = data.aws_iam_policy_document.data_perimeter_lambda.json
}

data "aws_iam_policy_document" "data_perimeter_lambda" {
  statement {
    sid = "Logs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Config"

    actions = [
      "config:PutEvaluations",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "data_perimeter_lambda" {
  role       = aws_iam_role.data_perimeter_lambda.id
  policy_arn = aws_iam_policy.data_perimeter_lambda.arn
}
