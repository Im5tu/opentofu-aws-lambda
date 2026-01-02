module "iam_this" {
  source = "git::https://github.com/im5tu/opentofu-aws-iam-role.git?ref=847ba166bc7c2e147573ff8d222487ca22347e15"

  name_prefix = var.name
  tags = merge(var.tags, {
    Name = var.name
  })
  assume_role_services     = ["lambda.amazonaws.com"]
  external_attachment_arns = concat(
    length(var.vpc_subnet_ids) > 0 ? ["arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"] : [],
    var.iam_policy_attachments
  )
  policies = merge(var.iam_inline_policies, {
    "cloudwatch"  = data.aws_iam_policy_document.cloudwatch.json
    "dead_letter" = data.aws_iam_policy_document.dead_letter.json
  })
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid    = "AllowCloudwatchLogsAccess"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [aws_cloudwatch_log_group.this.arn, "${aws_cloudwatch_log_group.this.arn}:*"]
  }
}

data "aws_iam_policy_document" "dead_letter" {
  statement {
    sid    = "AllowDeadLetterAccess"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sns:Publish"
    ]
    resources = [var.dead_letter_target_arn]
  }
}
