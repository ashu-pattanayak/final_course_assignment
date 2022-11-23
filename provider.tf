terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "1.3.5"
    }
  }


backend "s3" {
    bucket = "terraform-ashutosh"
    key    = "demo/terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
