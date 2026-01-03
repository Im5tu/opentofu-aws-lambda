# OpenTofu AWS Lambda Module

Creates an AWS Lambda function with CloudWatch logs, IAM role, and optional VPC configuration. Supports both Zip and container image deployments.

## Usage

```hcl
module "my_lambda" {
  source = "git::https://github.com/im5tu/opentofu-aws-lambda.git?ref=1ae587f69bc37a3faf4fae0aa35267dc91e8bdca"

  name                  = "my-function"
  handler               = "bootstrap"
  dead_letter_target_arn = aws_sqs_queue.dlq.arn
  function_zip_name     = "lambda.zip"
  function_zip_hash     = filebase64sha256("lambda.zip")

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| opentofu | >= 1.9 |
| aws | ~> 6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Lambda | `string` | n/a | yes |
| dead_letter_target_arn | ARN of SNS topic or SQS queue for failed async invocations | `string` | n/a | yes |
| handler | The handler to use in this function (required for Zip) | `string` | `null` | no |
| description | Description of what this lambda does | `string` | `""` | no |
| function_zip_name | The name of the zip file to upload | `string` | `null` | no |
| function_zip_hash | The hash of the uploaded zip file | `string` | `null` | no |
| image_uri | ECR image URI when using container images | `string` | `null` | no |
| package_type | The Lambda package type. Valid values are Zip and Image | `string` | `"Zip"` | no |
| function_architecture | The architecture to be used for the lambda. Options: x86_64 / arm64 | `string` | `"arm64"` | no |
| function_runtime | The runtime used to execute the function | `string` | `"provided.al2023"` | no |
| function_memory_in_mb | Amount of memory in MB the Lambda function can use at runtime | `number` | `1536` | no |
| function_timeout_in_seconds | The amount of time in seconds the Lambda function has to run | `number` | `300` | no |
| function_reserved_concurrent_executions | Set the number of the reserved concurrent executions | `number` | `-1` | no |
| environment_variables | Map of environment variables accessible from the function code | `map(string)` | `{}` | no |
| cloudwatch_logs_retention_in_days | Number of days to retain log events | `number` | `365` | no |
| kms_key_arn | The ARN of the KMS key used to encrypt cloudwatch logs | `string` | `null` | no |
| iam_inline_policies | The inline policies to add to the Lambda IAM role | `map(string)` | `{}` | no |
| iam_policy_attachments | The list of IAM Policy ARNs to attach to the IAM role | `list(string)` | `[]` | no |
| vpc_subnet_ids | List of subnet IDs for VPC configuration | `list(string)` | `[]` | no |
| vpc_security_group_ids | List of security group IDs for VPC configuration | `list(string)` | `[]` | no |
| tags | Tags that are specific to this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the function |
| name | The name of the function |
| invoke_arn | The invoke ARN of the function (for API Gateway integrations) |
| role_arn | The ARN of the Lambda execution role |
| log_group_name | The name of the Lambda log group |
| log_group_arn | The ARN of the Lambda log group |

## Development

### Validation

This module uses GitHub Actions for validation:

- **Format check**: `tofu fmt -check -recursive`
- **Validation**: `tofu validate`
- **Security scanning**: Checkov, Trivy

### Local Development

```bash
# Format code
tofu fmt -recursive

# Validate
tofu init -backend=false
tofu validate
```

## License

MIT License - see [LICENSE](LICENSE) for details.
