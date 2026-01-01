resource "aws_lambda_function" "handler_lambda" {
  function_name                  = var.name
  description                    = var.description
  handler                        = var.package_type == "Zip" ? var.handler : null
  filename                       = var.package_type == "Zip" ? var.function_zip_name : null
  source_code_hash               = var.package_type == "Zip" ? var.function_zip_hash : null
  image_uri                      = var.package_type == "Image" ? var.image_uri : null
  runtime                        = var.package_type == "Zip" ? var.function_runtime : null
  architectures                  = [var.function_architecture]
  memory_size                    = var.function_memory_in_mb
  timeout                        = var.function_timeout_in_seconds
  reserved_concurrent_executions = var.function_reserved_concurrent_executions
  role                           = module.iam_this.arn
  package_type                   = var.package_type
  kms_key_arn                    = var.kms_key_arn
  tags = merge(var.tags, {
    Name = var.name
  })

  # VPC configuration (only when subnets are provided)
  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  environment {
    variables = var.environment_variables
  }

  logging_config {
    application_log_level = "INFO"
    log_format            = "JSON"
    system_log_level      = "INFO"
  }
}
