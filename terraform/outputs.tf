output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres.address
  description = "RDS PostgreSQL endpoint"
}

output "rds_port" {
  value       = aws_db_instance.postgres.port
  description = "RDS PostgreSQL port"
}