resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "practice_step_functions"
  role_arn = aws_iam_role.iam_for_sfn.arn


    definition = jsonencode({
        Comment = "A first go at Step Functions"
        StartAt = "Process_Lambda"
        States = {
            Process_Lambda = {
                Type = "Task"
                Resource = "arn:aws:states:::lambda:invoke"
                Parameters = {
                    "FunctionName" = "${aws_lambda_function.process_lambda.arn}"
                    "Payload.$" = "$"
                }
                ResultPath = "$.process_output"
                Next = "ChoiceState"
            }
            ### Choice State - determine whether to trigger second lambda or not based on output of first
            ChoiceState = {
                Type = "Choice"
                Choices = [
                {
                    Variable = "$.process_output.Payload.value"
                    NumericGreaterThan = 7
                    Next = "Lambda_2"
                }
                ]
                Default = "End_State"  # Default to end the state machine
            }
            Lambda_2 = {
                Type = "Task"
                Resource = "arn:aws:states:::lambda:invoke"
                Parameters = {
                    "FunctionName" = "${aws_lambda_function.lambda_2.arn}"
                    "Payload.$" = "$.process_output.Payload"
                }
                ResultPath = "$.lambda_2_output"
                End = true
            }
            End_State = {
                Type = "Pass"
                End = true
            }

        }

    })
}
#   definition = <<EOF
# {
#   "Comment": "A first go at AWS Step Functions!",
#   "StartAt": "HelloWorld",
#   "States": {
#     "HelloWorld": {
#       "Type": "Task",
#       "Resource": "${aws_lambda_function.process_lambda.arn}",
#       "End": true
#     }
#   }
# }
# EOF
# }

### Assume Role

resource "aws_iam_role" "iam_for_sfn" {
    name = "practice_sfn_role"
    assume_role_policy = data.aws_iam_policy_document.sfn_role.json
}

data "aws_iam_policy_document" "sfn_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


### Permissions

resource "aws_iam_policy" "practice_sfn_policy" {
  name = "sfn-policy"

  policy = data.aws_iam_policy_document.sfn_lambda_policy.json
}

data "aws_iam_policy_document" "sfn_lambda_policy"  {

  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [aws_lambda_function.lambda_2.arn,
                aws_lambda_function.process_lambda.arn]
  }
}

resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.practice_sfn_policy.arn
}