resource "aws_efs_file_system" "minecraft" {
  creation_token = "${var.project_name}-${var.environment}"
  tags           = local.common_tags
}

resource "aws_efs_mount_target" "minecraft" {
  file_system_id  = aws_efs_file_system.minecraft.id
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.ecs_sg.id]
}
