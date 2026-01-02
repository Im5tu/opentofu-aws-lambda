output "arn" {
  description = "The ARN of the function"
  value       = aws_lambda_function.handler_lambda.arn
}

output "name" {
  description = "The name of the function"
  value       = aws_lambda_function.handler_lambda.function_name
}

output "invoke_arn" {
  description = "The invoke ARN of the function (for API Gateway integrations)"
  value       = aws_lambda_function.handler_lambda.invoke_arn
}

output "role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = module.iam_this.arn
}

output "log_group_name" {
  description = "The name of the Lambda log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "The ARN of the Lambda log group"
  value       = aws_cloudwatch_log_group.this.arn
}