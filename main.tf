terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
  #  backend "s3" {
  #   bucket         = "tfstate-save-bucket"
  #   key            = "dev/dev-terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "tfstate-Locktable" 
  # }
}

provider "aws" {
  region =  "us-east-1"
  profile = "default"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
