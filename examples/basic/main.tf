module "dlq" {
  source = "git::https://github.com/im5tu/opentofu-aws-sqs.git?ref=ce6739558c2324144583524879532e603c044dea"

  name       = "example-lambda-dlq"
  enable_dlq = false
}

module "example" {
  source = "../.."

  name                   = "example-lambda"
  dead_letter_target_arn = module.dlq.arn
  handler                = "bootstrap"
  function_zip_name      = "function.zip"
  function_zip_hash      = filebase64sha256("function.zip")
  tags = {
    Environment = "example"
  }
}
