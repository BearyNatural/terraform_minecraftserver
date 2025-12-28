resource "aws_ecs_cluster" "minecraft" {
  name = "${var.project_name}-${var.environment}"
  tags = local.common_tags
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow game ports and ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_policy" "ecs_execution_least_privilege_policy" {
  name        = "${var.project_name}-${var.environment}-ecs-execution-policy"
  description = "Least privilege policy for ECS task execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # CloudWatch Logs
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },

      # EFS mount and write
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ],
        Resource = "*"
      },

      # S3 upload backup
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::minecraft-cluster${var.environment_number}-${var.seed}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_least_privilege_policy.arn
}


resource "aws_ecs_task_definition" "minecraft_task" {
  family                   = "minecraft-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "minecraft",
      image     = "itzg/minecraft-server",
      essential = true,
      portMappings = [
        {
          containerPort = 25565
          hostPort      = 25565
        }
      ],
      environment = [
        {
          name  = "EULA"
          value = "TRUE"
        }
      ],
      mountPoints = [
        {
          containerPath = "/data"
          sourceVolume  = "minecraftdata"
        }
      ]
    }
  ])

  volume {
    name = "minecraftdata"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.minecraft.id
      root_directory = "/"
    }
  }

  tags = local.common_tags
}

resource "aws_ecs_service" "minecraft" {
  name            = "minecraft-service-${var.environment}"
  cluster         = aws_ecs_cluster.minecraft.id
  task_definition = aws_ecs_task_definition.minecraft_task.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  tags = local.common_tags
}
