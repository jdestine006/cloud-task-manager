variable "project_name" {
  default = "cloud-task-manager"
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