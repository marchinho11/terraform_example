terraform {
  backend "s3" {
    bucket = "terraform-netology"
    key    = "terraform"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}
