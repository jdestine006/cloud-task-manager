output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}