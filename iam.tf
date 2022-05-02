resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

resource "aws_iam_role" "lambda_ec2_scheduler" {
  name = "ec2-scheduler-${random_string.random.result}"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			 "Action": "sts:AssumeRole",
			 "Principal": {
			 "Service": "lambda.amazonaws.com"
			 },
			 "Effect": "Allow",
			 "Sid": ""
		}
	]
}
EOF
}

resource "aws_iam_role_policy" "lambda_ec2_scheduler" {
  name = substr("ec2-scheduler-${join(",", var.identifiers)}-${random_string.random.result}", 0, 64)
  role = aws_iam_role.lambda_ec2_scheduler.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": [
        "*"
      ]
		},
		{
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
        "logs:PutLogEvents"
			],
			"Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}
