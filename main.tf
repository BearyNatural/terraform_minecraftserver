terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "minecraft"
}

locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Deployed_by = "terraform"
    },
    var.tags
  )
}
