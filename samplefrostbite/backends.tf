terraform {
  backend "s3" {
    bucket = "atlantabucket24"
    key    = "terraform/dev/terraform_dev.tfstate"
    region = "us-east-1"
  }
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}