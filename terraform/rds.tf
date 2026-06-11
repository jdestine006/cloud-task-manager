# DB Subnet Group
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name = "cloud-task-manager-postgres-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "cloud-task-manager-postgres-subnet-group"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier = "cloud-task-manager-postgres"

  engine         = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "cloudtaskmanager"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  apply_immediately = true

  tags = {
    Name = "cloud-task-manager-postgres"
  }
}