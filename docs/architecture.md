# Cloud Task Manager Architecture

```mermaid
flowchart TB
    user[User / Client] --> alb[Application Load Balancer]

    alb --> ecs[ECS Fargate Service<br/>FastAPI Container]

    ecs --> rds[(Amazon RDS<br/>PostgreSQL)]
    ecs --> secrets[AWS Secrets Manager<br/>DB Credentials]
    ecs --> logs[CloudWatch Logs]

    github[GitHub Repository] --> actions[GitHub Actions CI/CD]
    actions --> ecr[Amazon ECR]
    ecr --> ecs

    cw[CloudWatch Dashboard & Alarms] --> sns[SNS Email Alerts]

    subgraph VPC[Custom VPC]
        subgraph Public[Public Subnets]
            alb
            nat[NAT Gateway]
        end

        subgraph Private[Private Subnets]
            ecs
            rds
        end
    end

    ecs --> nat