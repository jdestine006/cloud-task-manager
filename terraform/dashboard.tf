resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "cloud-task-manager-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS CPU Utilization"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.main.name,
              "ServiceName",
              aws_ecs_service.app.name
            ]
          ]
          stat   = "Average"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS Memory Utilization"
          region = var.aws_region
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.main.name,
              "ServiceName",
              aws_ecs_service.app.name
            ]
          ]
          stat   = "Average"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "RDS CPU Utilization"
          region = var.aws_region
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              aws_db_instance.postgres.id
            ]
          ]
          stat   = "Average"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "RDS Database Connections"
          region = var.aws_region
          metrics = [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              aws_db_instance.postgres.id
            ]
          ]
          stat   = "Average"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "ALB Request Count"
          region = var.aws_region
          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              aws_lb.app.arn_suffix
            ]
          ]
          stat   = "Sum"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "ALB Target Response Time"
          region = var.aws_region
          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              aws_lb.app.arn_suffix
            ]
          ]
          stat   = "Average"
          period = 60
        }
      }
    ]
  })
}