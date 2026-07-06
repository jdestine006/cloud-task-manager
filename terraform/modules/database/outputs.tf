output "address" {
  description = "Endpoint address of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgres.address
}

output "port" {
  description = "Port exposed by the PostgreSQL instance"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Initial database name"
  value       = aws_db_instance.postgres.db_name
}

output "identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.postgres.id
}