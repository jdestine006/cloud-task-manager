# ECS Cluster

resource "aws_ecs_cluster" "main" {
  name = "cloud-task-manager-cluster"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/cloud-task-manager"
  retention_in_days = 7
}




resource "aws_ecs_task_definition" "app" {
  family                   = "cloud-task-manager"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name = "cloud-task-manager"

      image = "${var.ecr_repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = "${var.db_secret_arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_secret_arn}:password::"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_PORT"
          value = var.db_port
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
    }
  ])
}
# ECS Service

resource "aws_ecs_service" "app" {
  name            = "cloud-task-manager-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids

    security_groups = [ var.ecs_security_group_id ] 

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn

    container_name = "cloud-task-manager"

    container_port = 8000
  }

  depends_on = [
  var.alb_listener_dependency
  ]
}

