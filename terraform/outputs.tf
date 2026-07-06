output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.database.address
}

output "rds_port" {
  description = "RDS port"
  value       = module.database.port
}