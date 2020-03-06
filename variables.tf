variable "name" {
  description = "Lambda API name"
  type        = string
}

variable "description" {
  description = "Lambda description"
  type        = string
  default     = ""
}

variable "kms_access" {
  description = "S3 access by name (read)"
  type        = bool
  default     = false
}

variable "s3_access" {
  description = "S3 access by name (read/write)"
  type = object({
    read  = list(string)
    write = list(string)
  })
  default = {
    read  = []
    write = []
  }
}

variable "sqs_access" {
  description = "SQS Queue access by ARN (read/write)"
  type        = list(string)
  default     = []
}

variable "sns_access" {
  description = "SNS access by ARN (write)"
  type        = list(string)
  default     = []
}

variable "sqs_read_access" {
  description = "SQS Queue access by ARN read"
  type        = list(string)
  default     = []
}

variable "function_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "filename" {
  description = "Lambda File name"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "methods" {
  description = "Method to call endpoint"
  type        = list(string)
  default     = ["POST"]
}

# variable "rest_api_id" {
#   description = "Optional -- aws_api_gateway_rest_api if not provided"
#   type        = string
#   default     = ""
# }

# variable "rest_path_id" {
#   description = "Optional -- aws_api_gateway_rest_api if not provided"
#   type        = string
#   default     = ""
# }

variable "tags" {
  type    = map(string)
  default = null
}

variable "environment" {
  description = "Environment configuration for the Lambda function"
  type = object({
    variables = map(string)
  })
  default = null
}

variable "vpc_config" {
  description = "Security group and subnet configuration"
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "timeout" {
  description = "Lambda timeout"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Memory Size"
  type        = number
  default     = 128
}

variable "cloudwatch_logs" {
  description = "Set this to false to disable logging your Lambda output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "policy" {
  description = "An additional policy to attach to the Lambda function role"
  type = object({
    json = string
  })
  default = null
}

variable "create_empty_function" {
  default = false
}

variable "aws_region" {
  type    = string
  default = false
}
