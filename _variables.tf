variable "identifiers" {
  description = "EC2 instance identifier for schedule"
}

variable "cron_stop" {
  description = "Cron expression to define when to trigger a stop of the Instance"
}

variable "cron_start" {
  description = "Cron expression to define when to trigger a start of the Instance"
}

variable "enable_start" {
  default = true
}

variable "enable_stop" {
  default = true
}

