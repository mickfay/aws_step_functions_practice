terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "practice-state-bucket20240711104027122600000001"
    key    = "process_practice"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

