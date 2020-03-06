locals {
  filename = var.create_empty_function ? "${path.module}/placeholder.zip" : var.filename
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  description      = var.description
  runtime          = var.runtime
  timeout          = var.timeout
  handler          = var.handler
  role             = aws_iam_role.lambda.arn
  filename         = local.filename
  source_code_hash = filebase64sha256(local.filename)


  memory_size = var.memory_size
  // reserved_concurrent_executions = var.reserved_concurrent_executions
  // layers                         = var.layers
  // publish                        = local.publish
  tags = var.tags

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  // TO add - dead_letter_config
}

resource "aws_cloudwatch_log_group" "logs" {
  count             = var.cloudwatch_logs ? 1 : 0
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 3
}
