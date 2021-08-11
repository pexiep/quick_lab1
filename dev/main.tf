
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

    vpc_cidr             = "10.1.0.0/16"
    tenancy              = "default"
    vpc_public_subnets   = ""
    vpc_id               = "${modules.vpc.vpc_id}"
   
}

