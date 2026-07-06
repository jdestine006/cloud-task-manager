resource "aws_lb" "app" {
  name = "cloud-task-manager-alb"

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = module.networking.public_subnet_ids
}

# Target Group 
resource "aws_lb_target_group" "app" {
  name        = "cloud-task-manager-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = module.networking.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}