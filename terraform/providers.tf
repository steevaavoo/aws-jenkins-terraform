terraform {
  backend "s3" {
    bucket = "steevaavoo-tfstate"
    key    = "tfstate"
    region = "us-west-2"
  }
}
