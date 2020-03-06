// SNS access (write)
data "aws_iam_policy_document" "sns" {
  statement {
    effect = "Allow"

    actions = [
      // Write methods
      "sns:Publish",
    ]

    resources = var.sns_access
  }
}

resource "aws_iam_policy" "sns" {
  count = length(var.sns_access) > 0 ? 1 : 0

  name   = "${var.function_name}-sns"
  policy = data.aws_iam_policy_document.sns.json
}

resource "aws_iam_policy_attachment" "sns" {
  count = length(var.sns_access) > 0 ? 1 : 0

  name       = "${var.function_name}-sns"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.sns[0].arn
}
