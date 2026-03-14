terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "cloud-lab-tfstate-211661224499"
    key            = "cloud-lab/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "cloud-lab-tfstate-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
