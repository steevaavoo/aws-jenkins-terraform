# Create some resource in AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.AWS_DEFAULT_REGION
}

resource "aws_ecr_repository" "eks" {
  name                 = var.ECR_NAME
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
