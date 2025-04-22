resource "aws_ecs_cluster" "backend" {
  name = "${var.project_name}-ecs-cluster-backend"
}

resource "aws_iam_role" "backend_task_execution" {
  name = "${var.project_name}-backend-task-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.backend_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "backend_task" {
  name = "${var.project_name}-backend-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "backend_task_policy" {
  role       = aws_iam_role.backend_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ecs_task_definition" "backend" {
  container_definitions = jsonencode([
    {
      name      = "backend-proxy"
      image     = "nginx"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  family                   = "${var.project_name}-backend"
  cpu                      = var.backend_ecs_task_cpu
  memory                   = var.backend_ecs_task_memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.backend_task_execution.arn
  task_role_arn            = aws_iam_role.backend_task.arn
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "backend" {
  name                   = "${var.project_name}-ecs-service-backend"
  cluster                = aws_ecs_cluster.backend.id
  task_definition        = aws_ecs_task_definition.backend.arn
  desired_count          = var.backend_ecs_service_initial_desired_count
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.app_alb_target.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "backend-proxy"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.app]
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.project_name}/app"
}

resource "aws_cloudwatch_log_group" "proxy" {
  name = "/ecs/${var.project_name}/proxy"
}
