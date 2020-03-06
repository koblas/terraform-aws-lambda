// SQS access (read/write)
data "aws_iam_policy_document" "sqs" {
  statement {
    effect = "Allow"

    actions = [
      // General methods
      "sqs:GetQueueUrl",

      // Write methods
      "sqs:SendMessage",

      // Read methods
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]

    resources = var.sqs_access
  }
}

resource "aws_iam_policy" "sqs" {
  count = length(var.sqs_access) > 0 ? 1 : 0

  name   = "${var.function_name}-sqs"
  policy = data.aws_iam_policy_document.sqs.json
}

resource "aws_iam_policy_attachment" "sqs" {
  count = length(var.sqs_access) > 0 ? 1 : 0

  name       = "${var.function_name}-sqs"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.sqs[0].arn
}
