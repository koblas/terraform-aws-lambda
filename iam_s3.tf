// S3 bucket access (read/write)
locals {
  s3_read_write = distinct(concat(var.s3_access.read, var.s3_access.write))
  s3_has_read   = length(var.s3_access.read) != 0
  s3_has_write  = length(var.s3_access.write) != 0
}

data "aws_iam_policy_document" "s3" {
  dynamic "statement" {
    for_each = local.s3_has_read || local.s3_has_write ? { one : 1 } : {}

    content {
      sid    = "LocateBucket"
      effect = "Allow"
      actions = [
        "s3:GetBucketLocation",
      ]

      resources = [for v in local.s3_read_write : "arn:aws:s3:::${v}"]
    }
  }

  dynamic "statement" {
    for_each = local.s3_has_read ? { one : 1 } : {}

    content {
      sid    = "ListObjectActions"
      effect = "Allow"
      actions = [
        "s3:ListBucket",
      ]

      resources = [for v in var.s3_access.read : "arn:aws:s3:::${v}"]
    }
  }

  dynamic "statement" {
    for_each = local.s3_has_read ? { one : 1 } : {}

    content {
      sid    = "GetObjectActions"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        // "s3:GetObjectAcl",
      ]

      resources = [for v in var.s3_access.read : "arn:aws:s3:::${v}/*"]
    }
  }

  dynamic "statement" {
    for_each = local.s3_has_write ? { one : 1 } : {}

    content {
      sid    = "PutObjectActions"
      effect = "Allow"
      actions = [
        "s3:PutObject",
        // "s3:PutObjectAcl",
      ]

      resources = [for v in var.s3_access.write : "arn:aws:s3:::${v}/*"]
    }
  }
}

resource "aws_iam_policy" "s3" {
  count = local.s3_has_read || local.s3_has_write ? 1 : 0

  name   = "${var.function_name}-s3"
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_policy_attachment" "s3" {
  count = local.s3_has_read || local.s3_has_write ? 1 : 0

  name       = "${var.function_name}-network"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.s3[0].arn
}
