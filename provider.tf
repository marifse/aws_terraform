terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
	bucket = "terraform-backend-state-12"
	key = "infra-network/tfstate"
	region = "ap-southeast-2"
  }
}

provider "aws" {
  region = var.AWS_REGION
}