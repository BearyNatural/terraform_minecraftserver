variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  description = "Deployment environment (dev, prod)"
  type        = string
}

variable "environment_number" {
  description = "Used to suffix S3 bucket name (e.g., cluster5)"
  type        = string
}

variable "seed" {
  description = "Minecraft world seed"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "az" {
  type = string
}
