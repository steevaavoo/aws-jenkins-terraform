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
# TODO: Complete the EKS setup starting with VPC - see https://learn.hashicorp.com/tutorials/terraform/eks
# TODO: Uncomment the commented outputs in outputs.tf when you enable the below
# resource "aws_iam_role" "eks" {
#   name = "eks-cluster-eks"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks.name
# }

# # Optionally, enable Security Groups for Pods
# # Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
# resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks.name
# }

# resource "aws_eks_cluster" "eks" {
#   name     = "eks"
#   role_arn = aws_iam_role.eks.arn

#   vpc_config {
#     subnet_ids = [aws_subnet.eks1.id, aws_subnet.eks2.id]
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
#   ]
# }
