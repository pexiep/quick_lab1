
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "my_vpc" {
    source = "../Modules/VPC"

    vpc_name             = "non-prod"
    vpc_cidr             = "10.1.0.0/16"
    vpc_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
    vpc_private_subnets  = ["10.1.10.0/24", "10.1.11.0/24", "10.1.22.0/24"]
    vpc_public_subnets   = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
    vpc_db_subnets       = ["10.1.100.0/24", "10.1.110.0/24", "10.1.220.0/24"]
}

