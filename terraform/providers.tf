terraform {
  backend "s3" {
    bucket = var.TERRAFORM_BUCKET_NAME
    key    = "tfstate"
    region = var.AWS_DEFAULT_REGION
  }
}
