
// Attach an additional policy if provided.
resource "aws_iam_policy" "additional" {
  count = var.policy == null ? 0 : 1

  name   = var.function_name
  policy = var.policy.json
}

resource "aws_iam_policy_attachment" "additional" {
  count = var.policy == null ? 0 : 1

  name       = var.function_name
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.additional[0].arn
}
