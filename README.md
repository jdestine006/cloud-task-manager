# Cloud Task Manager

Cloud Task Manager is a production-style AWS portfolio project demonstrating containerized application deployment, secure networking, PostgreSQL persistence, CI/CD automation, observability, alerting, auto scaling, and modular Infrastructure as Code.

## Architecture

This project deploys a FastAPI task management API on AWS using ECS Fargate behind an Application Load Balancer, with PostgreSQL persistence through Amazon RDS.

The infrastructure is provisioned with Terraform and organized into reusable modules for networking, security, database, ECS, monitoring, and auto scaling.

## Key Features

* Containerized FastAPI application using Docker
* ECS Fargate deployment behind an Application Load Balancer
* Amazon RDS PostgreSQL database in private subnets
* Secure database credentials using AWS Secrets Manager
* Custom VPC with public and private subnets
* NAT Gateway for private subnet outbound access
* GitHub Actions CI/CD pipeline
* Amazon ECR image repository
* CloudWatch logs, dashboard, and alarms
* SNS email notifications
* ECS target-tracking auto scaling
* k6 load testing validation
* Modular Terraform architecture

## AWS Services Used

* Amazon ECS Fargate
* Amazon ECR
* Amazon RDS PostgreSQL
* Application Load Balancer
* Amazon VPC
* NAT Gateway
* AWS Secrets Manager
* AWS IAM
* Amazon CloudWatch
* Amazon SNS
* AWS Application Auto Scaling

## Terraform Module Structure

```text
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── alb.tf
├── ecr.tf
├── security_groups.tf
└── modules/
    ├── networking/
    ├── security/
    ├── database/
    ├── ecs/
    ├── monitoring/
    └── autoscaling/
```

## CI/CD Pipeline

GitHub Actions automatically builds the Docker image, pushes it to Amazon ECR, and triggers a new ECS deployment when changes are pushed to the main branch.

```text
GitHub
  → GitHub Actions
  → Docker build
  → Amazon ECR
  → ECS Fargate deployment
```

## Observability and Alerting

The project includes CloudWatch dashboards and alarms for ECS, ALB, and RDS metrics.

Monitored metrics include:

* ECS CPU utilization
* ECS memory utilization
* RDS CPU utilization
* RDS free storage
* ALB request count
* ALB target response time
* RDS database connections

SNS email notifications are triggered when configured alarm thresholds are crossed.

## Auto Scaling Validation

ECS Service Auto Scaling was configured with:

* Minimum tasks: 1
* Maximum tasks: 3
* Target CPU utilization: 70%
* Scale-out cooldown: 60 seconds
* Scale-in cooldown: 300 seconds

Load testing was performed using k6. During testing, CPU utilization crossed the configured threshold, CloudWatch alarms entered ALARM state, SNS email notifications were delivered, and ECS increased the desired task count automatically.

## Key Troubleshooting Milestones

This project included several real-world cloud troubleshooting scenarios:

* Fixed ECS-to-ECR connectivity caused by private route table misconfiguration
* Corrected NAT Gateway routing for private subnet outbound access
* Resolved ECR authentication and image push issues
* Configured ECS Secrets Manager integration
* Validated ECS-to-RDS private connectivity
* Fixed FastAPI serialization issues with SQLAlchemy objects
* Refactored monolithic Terraform into reusable modules

## Architecture Decisions

### ECS Fargate

Fargate was selected to reduce server management overhead and focus on containerized application architecture.

### Private Subnets

ECS tasks and RDS were placed in private subnets to reduce public exposure and follow secure networking practices.

### Secrets Manager

Database credentials are stored in Secrets Manager and injected into ECS task definitions at runtime.

### Terraform Modules

The infrastructure was refactored into reusable modules to improve maintainability, separation of concerns, and scalability of the Terraform codebase.

## Future Enhancements

* HTTPS with AWS Certificate Manager and custom domain
* Blue/green deployments
* AWS WAF integration
* Terratest infrastructure tests
* Multi-environment deployment strategy
* JWT authentication
* OpenTelemetry tracing
