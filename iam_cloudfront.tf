locals {
  lambda_log_group_arn = "arn:${data.aws_partition.current.partition}:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}"
  log_group_arns       = [local.lambda_log_group_arn]
}

// Cloudwatch logging of the lambda
data "aws_iam_policy_document" "logs" {
  count = var.cloudwatch_logs ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = concat(formatlist("%v:*", local.log_group_arns), formatlist("%v:*:*", local.log_group_arns))
  }
}

resource "aws_iam_policy" "logs" {
  count = var.cloudwatch_logs ? 1 : 0

  name   = "${var.function_name}-logs"
  policy = data.aws_iam_policy_document.logs[0].json
}

resource "aws_iam_policy_attachment" "logs" {
  count = var.cloudwatch_logs ? 1 : 0

  name       = "${var.function_name}-logs"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.logs[0].arn
}
