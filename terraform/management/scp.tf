data "aws_organizations_organization" "org" {}

resource "aws_organizations_policy" "non_prod_data_perimeter" {
  name        = "data-perimeter-non-prod"
  description = "This SCP stops data moving between non prod and prod accounts from non prod users/services"
  content     = data.aws_iam_policy_document.non_prod_data_perimeter.json
}

resource "aws_organizations_policy_attachment" "non_prod_data_perimeter" {
  count     = length(var.prod_ous)
  policy_id = aws_organizations_policy.non_prod_data_perimeter.id
  target_id = var.non_prod_ous[count.index]
}

data "aws_iam_policy_document" "non_prod_data_perimeter" {
  statement {
    effect = "Deny"
    actions = [
      "s3:*",
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:ResourceOrgPaths"

      values = [
        var.prod_org_path,
      ]
    }
  }
}

resource "aws_organizations_policy" "prod_data_perimeter" {
  name        = "data-perimeter-prod"
  description = "This SCP stops data moving from prod to non prod accounts from prod users/services"
  content     = data.aws_iam_policy_document.prod_data_perimeter.json
}

resource "aws_organizations_policy_attachment" "prod_data_perimeter" {
  count     = length(var.prod_ous)
  policy_id = aws_organizations_policy.prod_data_perimeter.id
  target_id = var.prod_ous[count.index]
}

data "aws_iam_policy_document" "prod_data_perimeter" {
  statement {
    effect = "Deny"
    actions = [
      "s3:Put*",
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringNotLike"
      variable = "aws:ResourceOrgPaths"

      values = [
        var.prod_org_path,
      ]
    }
  }
}
