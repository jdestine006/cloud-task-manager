module "networking" {
  source       = "./modules/networking"
  aws_region   = var.aws_region
  project_name = var.project_name
}

module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  private_subnet_ids    = module.networking.private_subnet_ids
  rds_security_group_id = aws_security_group.rds_sg.id

  db_username = var.db_username
  db_password = var.db_password
}

module "ecs" {
  source = "./modules/ecs"

  project_name            = var.project_name
  aws_region              = var.aws_region
  private_subnet_ids      = module.networking.private_subnet_ids
  ecs_security_group_id   = aws_security_group.ecs_sg.id
  target_group_arn        = aws_lb_target_group.app.arn
  alb_listener_dependency = aws_lb_listener.http

  ecr_repository_url = aws_ecr_repository.app.repository_url

  db_host            = module.database.address
  db_port            = tostring(module.database.port)
  db_name            = module.database.db_name
  db_secret_arn      = module.security.db_secret_arn
  execution_role_arn = module.security.ecs_task_execution_role_arn
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  db_username  = var.db_username
  db_password  = var.db_password
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name   = var.project_name
  aws_region     = var.aws_region
  cluster_name   = module.ecs.cluster_name
  service_name   = module.ecs.service_name
  db_identifier  = module.database.identifier
  alb_arn_suffix = aws_lb.app.arn_suffix
  alert_email    = var.alert_email
}

module "autoscaling" {
  source = "./modules/autoscaling"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}