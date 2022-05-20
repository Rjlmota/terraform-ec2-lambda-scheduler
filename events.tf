resource "aws_cloudwatch_event_rule" "lambda_ec2_scheduler_start" {
  name                = "ec2-scheduler-start-${random_string.random.result}"
  description         = "Start EC2 instances ${join(",", var.identifiers)} at beginning of business hours."
  schedule_expression = "cron(${var.cron_start})"
  is_enabled          = var.enable_start

  tags                = {Environment = "${var.name}"}

}

resource "aws_cloudwatch_event_target" "lambda_ec2_scheduler_start" {
  rule      = aws_cloudwatch_event_rule.lambda_ec2_scheduler_start.name
  target_id = "ec2-scheduler-start-${random_string.random.result}"
  arn       = aws_lambda_function.lambda_ec2_scheduler.arn
  tags                = {Environment = "${var.name}"}

  input = <<EOI
{
	"action": "start",
	"ec2id": "${join(",", var.identifiers)}"
}
EOI
}

resource "aws_cloudwatch_event_rule" "lambda_ec2_scheduler_stop" {
  name                = "ec2-scheduler-stop-${random_string.random.result}"
  description         = "Stop ec2 instances ${join(",", var.identifiers)} at the end of business hours."
  schedule_expression = "cron(${var.cron_stop})"
  is_enabled          = var.enable_stop

  tags                = {Environment = "${var.name}"}
}

resource "aws_cloudwatch_event_target" "lambda_ec2_scheduler_stop" {
  rule      = aws_cloudwatch_event_rule.lambda_ec2_scheduler_stop.name
  target_id = "ec2-scheduler-stop-${random_string.random.result}"
  arn       = aws_lambda_function.lambda_ec2_scheduler.arn

  tags                = {Environment = "${var.name}"}


  input = <<EOI
{
	"action": "stop",
	"ec2id": "${join(",", var.identifiers)}"
}
EOI
}
