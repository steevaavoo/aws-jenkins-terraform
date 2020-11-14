# These variables are derived from environment variables set in the Environment
# section of the Jenkinsfile, prefixed with TF_VAR_
variable "AWS_DEFAULT_REGION" {
  type = string
}

variable "PREFIX" {
  type = string
}

variable "TERRAFORM_BUCKET_NAME" {
  type = string
}

variable "ECR_NAME" {
  type = string
}
