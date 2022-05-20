data "archive_file" "lambda_ec2_scheduler" {
  type        = "zip"
  source_file = "${path.module}/lambda-function/ec2-scheduler.py"
  output_path = "${path.module}/lambda-function/ec2-scheduler.zip"
}

resource "aws_lambda_function" "lambda_ec2_scheduler" {
  function_name = "${var.name}-ec2-scheduler-${random_string.random.result}"
  role          = aws_iam_role.lambda_ec2_scheduler.arn
  handler       = "ec2-scheduler.lambda_handler"
  filename      = data.archive_file.lambda_ec2_scheduler.output_path
  runtime       = "python3.8"
  timeout       = 15


  tags                = {"ENVIRONMENT": ${var.name}}

}

resource "aws_lambda_permission" "lambda_ec2_scheduler_start" {
  statement_id  = "AllowExecutionFromCloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_ec2_scheduler_start.arn

  tags                = {"ENVIRONMENT": ${var.name}}
}

resource "aws_lambda_permission" "lambda_ec2_scheduler_stop" {
  statement_id  = "AllowExecutionFromCloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_ec2_scheduler_stop.arn

  tags                = {"ENVIRONMENT": ${var.name}}
}
