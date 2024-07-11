resource "aws_lambda_function" "process_lambda" {
    function_name = "process_purchase"
    filename = "zipped_lambdas/process_purchase.zip"
    role = aws_iam_role.iam_for_process.arn
    handler = "process_purchase.process_purchase_handler"
    runtime = "python3.11"

    source_code_hash = data.archive_file.process_lambda.output_base64sha256
}

data "archive_file" "process_lambda" {
    type = "zip"
    source_file = "../src/process_purchase.py"
    output_path = "zipped_lambdas/process_purchase.zip"
}

resource "aws_iam_role" "iam_for_process" {
    name = "process_role"
    assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cloudwatch_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "lambda_policy"
  policy = data.aws_iam_policy_document.cloudwatch_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_attachment" {
  role       = aws_iam_role.iam_for_process.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}



resource "aws_lambda_function" "lambda_2" {
    function_name = "lambda_2"
    filename = "zipped_lambdas/lambda_2.zip"
    role = aws_iam_role.iam_for_process.arn
    handler = "lambda_2.lambda_handler"
    runtime = "python3.11"

    source_code_hash = data.archive_file.lambda_2.output_base64sha256
}

data "archive_file" "lambda_2" {
    type = "zip"
    source_file = "../src/lambda_2.py"
    output_path = "zipped_lambdas/lambda_2.zip"
}