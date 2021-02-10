resource "aws_cloudwatch_event_rule" "lambda_rds_scheduler_start" {
  name                = "rds-scheduler-start-${random_string.random.result}"
  description         = "Start RDS ${var.identifier} at beginning of business hours."
  schedule_expression = "cron(${var.cron_start})"
  is_enabled          = var.enable
}

resource "aws_cloudwatch_event_target" "lambda_rds_scheduler_start" {
  rule      = aws_cloudwatch_event_rule.lambda_rds_scheduler_start.name
  target_id = "rds-scheduler-start-${random_string.random.result}"
  arn       = aws_lambda_function.lambda_rds_scheduler.arn

  input = <<EOI
{
	"action": "start",
	"rdsid": "${var.identifier}",
	"is_cluster": "${var.is_cluster}"
}
EOI
}

resource "aws_cloudwatch_event_rule" "lambda_rds_scheduler_stop" {
  name                = "rds-scheduler-stop-${random_string.random.result}"
  description         = "Stop RDS ${var.identifier} at the end of business hours."
  schedule_expression = "cron(${var.cron_stop})"
  is_enabled          = var.enable
}

resource "aws_cloudwatch_event_target" "lambda_rds_scheduler_stop" {
  rule      = aws_cloudwatch_event_rule.lambda_rds_scheduler_stop.name
  target_id = "rds-scheduler-stop-${random_string.random.result}"
  arn       = aws_lambda_function.lambda_rds_scheduler.arn

  input = <<EOI
{
	"action": "stop",
	"rdsid": "${var.identifier}",
	"is_cluster": "${var.is_cluster}"
}
EOI
}

