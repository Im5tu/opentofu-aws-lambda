###########################################################
#  Standard Variables
###########################################################
variable "tags" {
  description = "Tags that are specific to this module"
  type        = map(string)
  default     = {}
}

###########################################################
#  Other variables
###########################################################
variable "name" {
  description = "The name of the Lambda"
  type        = string
}

variable "description" {
  description = "Description of what this lambda does"
  type        = string
  default     = ""
}

variable "handler" {
  description = "The handler to use in this function"
  type        = string
  default     = null
  validation {
    condition     = var.package_type != "Zip" || var.handler != null
    error_message = "Handler is required when package_type is 'Zip'."
  }
}

variable "function_zip_name" {
  description = "The name of the zip file to upload"
  type        = string
  default     = null
}

variable "function_zip_hash" {
  description = "The hash of the uploaded zip file"
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI when using container images"
  type        = string
  default     = null
}

variable "package_type" {
  description = "The Lambda package type. Valid values are Zip and Image"
  type        = string
  default     = "Zip"
  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "Package type must be either 'Zip' or 'Image'."
  }
}

variable "function_architecture" {
  description = "The architecture to be used for the lambda. Options: x86_64 / arm64"
  type        = string
  default     = "arm64"
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = 3
}

variable "iam_inline_policies" {
  description = "The inline policies to add to the Lambda IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_policy_attachments" {
  description = "The list of IAM Policy ARNs that you want to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used to encrypt cloudwatch logs. Does not support KMS Aliases."
  default     = null
}

variable "function_runtime" {
  description = "The runtime used to execute the function. For example dotnetcore2.1, dotnetcore3.1 or other supported values"
  type        = string
  default     = "provided.al2023"
}

variable "function_memory_in_mb" {
  description = "Amount of memory in MB the Lambda function can use at runtime. Default: 1536"
  type        = number
  default     = 1536
}

variable "function_timeout_in_seconds" {
  description = "The amount of time in seconds the Lambda function has to run. Default: 300 (5 minutes)"
  type        = number
  default     = 300
}

variable "function_reserved_concurrent_executions" {
  description = "Set the number of the reserved concurrent executions. Warning: Concurrency is subject to a Regional quota that is shared by all functions in a Region. Reserved concurrency guarantees the maximum number of concurrent instances for the function. When a function has reserved concurrency, no other function can use that concurrency even if not actively in use. Default: -1"
  default     = -1
  type        = number
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution."
  type        = map(string)
  default     = {}
}

###########################################################
#  VPC Configuration (Optional)
###########################################################
variable "vpc_subnet_ids" {
  description = "List of subnet IDs for VPC configuration. If empty, Lambda runs outside VPC."
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for VPC configuration. Only used when vpc_subnet_ids is provided."
  type        = list(string)
  default     = []
}
