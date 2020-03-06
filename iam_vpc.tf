
// VPC Networking
data "aws_iam_policy_document" "network" {
  count = var.vpc_config == null ? 0 : 1

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "network" {
  count = var.vpc_config == null ? 0 : 1

  name   = "${var.function_name}-network"
  policy = data.aws_iam_policy_document.network[0].json
}

resource "aws_iam_policy_attachment" "network" {
  count = var.vpc_config == null ? 0 : 1

  name       = "${var.function_name}-network"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.network[0].arn
}
