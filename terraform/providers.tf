terraform {
variable "AWS_DEFAULT_REGION" {
  type = string
}
variable "PREFIX" {
  type = string
}
variable "TERRAFORM_BUCKET_NAME" {
  type = string
}
  backend "s3" {
    bucket = var.TERRAFORM_BUCKET_NAME
    key    = "tfstate"
    region = var.AWS_DEFAULT_REGION
  }
}
