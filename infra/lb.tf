resource "aws_lb" "app" {
  name               = "${var.project_name}-alb-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "app" {
  listener_arn = aws_lb_listener.app.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    path                = "/up"
    matcher             = "200"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}
