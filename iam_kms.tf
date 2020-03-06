// SNS access (write)
data "aws_iam_policy_document" "kms" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
}

resource "aws_iam_policy" "kms" {
  count = var.kms_access ? 1 : 0

  name   = "${var.function_name}-kms"
  policy = data.aws_iam_policy_document.kms.json
}

resource "aws_iam_policy_attachment" "kms" {
  count = var.kms_access ? 1 : 0

  name       = "${var.function_name}-kms"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.kms[0].arn
}
