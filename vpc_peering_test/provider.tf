terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
  backend "s3" {
    bucket = "vpc-module-terraform"
    key    = "vpc-peering-state"
    region = "us-east-1"
    use_lockfile = true 
  }
}

provider "aws" {
  # Configuration options
}

