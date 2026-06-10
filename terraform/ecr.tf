resource "aws_ecr_repository" "app" {
  name = "cloud-task-manager"

  tags = {
    Name = "cloud-task-manager"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}