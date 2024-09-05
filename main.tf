provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}

# VPC Configuration
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnet Configuration
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"  
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.ecs_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECR Repository for the Medusa Backend Docker Image
# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the required policies for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecr_repository" "medusa_repo" {
  name = "medusa-backend"
}

# ECS Task Definition for Medusa Backend
resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn  

  container_definitions = jsonencode([
    {
      name      = "medusa-backend"
      image     = "${aws_ecr_repository.medusa_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# ECS Service for Medusa Backend
resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.public_subnet.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  launch_type = "FARGATE"
}

# ECS Cluster
resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-ecs-cluster"
}
