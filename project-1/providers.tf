terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["/Users/mac/.aws/credentials"]
  profile                  = "wari"
}