output "role_arn" {
  value = aws_iam_role.lambda.arn
}

output "role_name" {
  value = aws_iam_role.lambda.name
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

/*
output "log_arn" {
  value = aws_cloudwatch_log_group.logs.arn
}
*/

output "log_group" {
  value = "/aws/lambda/${var.function_name}"
}
