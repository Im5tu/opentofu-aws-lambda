locals {
  cloudwatch_log_group_name = "/aws/lambda/${var.name}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn

  tags = merge(var.tags, {
    Name = local.cloudwatch_log_group_name
  })
}
