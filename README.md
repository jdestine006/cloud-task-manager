# Cloud Task Manager

## Overview

Cloud Task Manager is a cloud-native task management application built on AWS using containerized microservice architecture principles. The project was designed to demonstrate production-style application deployment, secure networking, infrastructure automation, observability, and CI/CD practices commonly used in modern cloud environments.

The application provides a REST API for creating, retrieving, updating, and deleting tasks while leveraging AWS managed services for scalability, security, and operational excellence.

---

## Business Problem

Organizations frequently require lightweight internal applications that can be deployed rapidly while maintaining security, reliability, and operational visibility.

This project demonstrates how a simple business application can be architected using AWS managed services to achieve:

* Secure application deployment
* Automated infrastructure provisioning
* Database persistence
* Continuous delivery
* Monitoring and alerting
* Operational visibility

---
``` markdown
## Architecture Diagram

See full architecture diagram here: 

[Cloud Task Manager Architecture](docs/architecture.md)


## Solution Architecture

The solution uses a multi-tier AWS architecture consisting of:

### Application Layer

* FastAPI
* Docker
* SQLAlchemy
* PostgreSQL

### Compute Layer

* Amazon ECS Fargate
* Amazon ECR

### Networking Layer

* Custom VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Application Load Balancer

### Security Layer

* IAM Roles and Policies
* Security Groups
* AWS Secrets Manager

### Operations Layer

* Amazon CloudWatch Logs
* CloudWatch Dashboard
* CloudWatch Alarms
* Amazon SNS Notifications

### Deployment Layer

* GitHub Actions
* Terraform Infrastructure as Code

---

## Key Features

### Infrastructure as Code

All AWS resources are provisioned using Terraform, enabling repeatable and consistent deployments.

### Secure Network Architecture

Application containers run within private subnets and communicate with the internet through a NAT Gateway. Database resources remain isolated from direct public access.

### Containerized Deployment

The application is packaged as a Docker container and deployed to ECS Fargate, eliminating the need to manage underlying servers.

### Managed Database

Amazon RDS PostgreSQL provides persistent storage for application data.

### Secrets Management

Database credentials are stored securely in AWS Secrets Manager and injected into ECS tasks at runtime.

### CI/CD Automation

GitHub Actions automatically builds container images, pushes them to Amazon ECR, and triggers ECS deployments upon code changes.

### Monitoring and Alerting

CloudWatch dashboards and alarms provide operational visibility into application, database, and infrastructure health.

---

## Architecture Decisions

### ECS Fargate vs EC2

Fargate was selected to reduce operational overhead and focus on application architecture rather than server management.

### Private Subnets for ECS and RDS

Application containers and database resources were placed in private subnets to reduce attack surface and follow AWS security best practices.

### Secrets Manager vs Environment Variables

Sensitive credentials were stored in Secrets Manager rather than hardcoded configuration files to improve security and maintainability.

### Terraform vs Manual Provisioning

Terraform was chosen to demonstrate Infrastructure as Code practices and provide reproducible deployments.

---

## Monitoring Strategy

The platform includes:

### ECS Monitoring

* CPU Utilization
* Memory Utilization

### RDS Monitoring

* CPU Utilization
* Database Connections
* Free Storage Space

### Application Monitoring

* CloudWatch Logs
* Health Check Endpoints

### Alerting

Amazon SNS email notifications are triggered when infrastructure thresholds are exceeded.

---
## Load Testing and Auto Scaling Validation

### Objective

Validate that the ECS Fargate service could automatically scale in response to increased application load while maintaining application availability.

### Test Methodology

Load testing was performed using k6 against the production deployment hosted behind the Application Load Balancer.

Test traffic generated repeated requests to the task management API endpoints, including task retrieval and task creation operations.

### Scaling Configuration

The ECS service was configured using AWS Application Auto Scaling with the following parameters:

| Setting                | Value       |
| ---------------------- | ----------- |
| Minimum Tasks          | 1           |
| Maximum Tasks          | 3           |
| Target CPU Utilization | 70%         |
| Scale Out Cooldown     | 60 seconds  |
| Scale In Cooldown      | 300 seconds |

### Monitoring and Alerting

The platform was monitored using Amazon CloudWatch dashboards and alarms.

Observed metrics included:

* ECS CPU Utilization
* ECS Memory Utilization
* ALB Request Count
* ALB Target Response Time
* RDS Database Connections

Amazon SNS email notifications were configured to alert when CPU utilization exceeded the configured threshold.

### Results

During load testing:

1. Application traffic increased CPU utilization beyond the configured threshold.
2. CloudWatch alarms entered the ALARM state.
3. SNS notifications were delivered successfully via email.
4. ECS Auto Scaling increased the desired task count automatically.
5. Additional Fargate tasks were launched successfully.
6. Application availability was maintained throughout the test.

### Validation Outcome

The test successfully validated:

* CloudWatch metric collection
* CloudWatch alarm configuration
* SNS notification delivery
* ECS target-tracking auto scaling
* Container deployment health
* Application resiliency under increased load

### Operational Lessons Learned

This exercise demonstrated how AWS managed services can work together to provide a self-healing and scalable application platform.

The validation process also highlighted the importance of monitoring, alerting, and automated scaling policies when designing production-ready cloud architectures.

## Challenges and Troubleshooting

### ECS to ECR Connectivity Issue

The ECS service was unable to pull container images from ECR.

**Root Cause**

A private route table was incorrectly configured to use an Internet Gateway rather than a NAT Gateway.

**Resolution**

Updated the route table to use the NAT Gateway, restoring outbound connectivity for ECS tasks.

### Secrets Injection Configuration

The application initially failed to retrieve database credentials.

**Resolution**

Configured ECS task definitions and IAM permissions to retrieve secrets from AWS Secrets Manager.

### PostgreSQL Connectivity Validation

Database connectivity issues were identified during integration testing.

**Resolution**

Implemented health-check endpoints and validated secure communication between ECS tasks and Amazon RDS.

### FastAPI Serialization Issues

API endpoints experienced serialization errors when returning ORM objects.

**Resolution**

Implemented explicit response formatting and validated API responses against expected schemas.

---

## Results

The completed solution successfully demonstrates:

* Containerized application deployment on AWS
* Infrastructure automation with Terraform
* Secure secrets management
* PostgreSQL persistence
* Continuous deployment using GitHub Actions
* Monitoring and alerting using CloudWatch and SNS
* Production-style networking and security architecture

---

## Future Enhancements

Potential future improvements include:

* HTTPS with AWS Certificate Manager
* Blue/Green Deployments
* OpenTelemetry Integration
* Prometheus and Grafana Monitoring
* JWT Authentication
* Multi-Environment Deployments (Dev/Test/Prod)
* Terraform Modules
* Cost Optimization Reporting

---

## Technologies Used

* Python
* FastAPI
* SQLAlchemy
* PostgreSQL
* Docker
* Terraform
* AWS ECS Fargate
* Amazon ECR
* Amazon RDS
* AWS Secrets Manager
* Application Load Balancer
* Amazon CloudWatch
* Amazon SNS
* GitHub Actions
* IAM
* VPC Networking

## Project Highlights
* Designed and deployed a cloud-native application on AWS using ECS Fargate, RDS PostgreSQL, and Application Load Balancer.
* Implemented Infrastructure as Code using Terraform.
* Secured database credentials using AWS Secrets Manager.
* Built CI/CD automation using GitHub Actions and Amazon ECR.
* Implemented monitoring, alerting, and observability using CloudWatch and SNS.
* Designed ECS target-tracking auto scaling policies and validated scale-out behavior through load testing.
* Diagnosed and resolved real-world networking, deployment, authentication, and database connectivity issues.
* Created a production-style architecture using private subnets, NAT Gateway routing, and least-exposure networking principles.

