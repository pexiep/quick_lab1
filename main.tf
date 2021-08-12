 module "gft" {
    source = "./VPC"

    vpc_name             = "non-prod"
    vpc_cidr             = "10.1.0.0/16"
    vpc_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
    vpc_private_subnets  = ["10.1.10.0/24", "10.1.11.0/24", "10.1.22.0/24"]
    vpc_public_subnets   = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
    vpc_db_subnets       = ["10.1.100.0/24", "10.1.110.0/24", "10.1.220.0/24"]
}
