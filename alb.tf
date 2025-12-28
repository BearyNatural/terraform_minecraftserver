resource "aws_lb" "minecraft" {
  name               = "minecraft-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public.id]
  security_groups    = [aws_security_group.ecs_sg.id]
  tags               = local.common_tags
}

resource "aws_lb_target_group" "minecraft" {
  name        = "minecraft-tg-${var.environment}"
  port        = 25565
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    protocol = "TCP"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "minecraft" {
  load_balancer_arn = aws_lb.minecraft.arn
  port              = 25565
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.minecraft.arn
  }
}
