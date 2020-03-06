# IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "iam_for_lambda_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}
