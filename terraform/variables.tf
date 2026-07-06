variable "project_name" {
  description = "Project Name"
  default     = "cloud-task-manager"
  type        = string
}

variable "aws_region" {
  default = "us-east-1"
}

variable "db_username" {
  description = "PostgreSQL admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alarm notifications"
  type        = string
}