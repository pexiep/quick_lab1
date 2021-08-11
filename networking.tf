data "aws_availability_zones" "available" {
  state = "available"
}

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

#1 - Create VPC

resource "aws_vpc" "nonprod" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"

  # Required for EKS. Enable/disable DNS support in the VPC.
  enable_dns_support = true

  # Required for EKS. Enable/disable DNS hostnames in the VPC.
  enable_dns_hostnames = true

  tags = {
    Name = "nonprodVPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.nonprod.id
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_subnet" "public_subnet" {
  for_each = toset(var.vpc_public_subnets)

  vpc_id     = "${var.vpc_id}"
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.vpc_public_subnets, each.key)]


  tags = {
    Name = "Publicsubet_${index(var.vpc_public_subnets, each.key)}"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = toset(var.vpc_private_subnets)

  vpc_id     = "${var.vpc_id}"
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.vpc_private_subnets, each.key)]


  tags = {
    Name = "Publicsubet_${index(var.vpc_private_subnets, each.key)}"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_subnet" "db_subnet" {
  for_each = toset(var.vpc_db_subnets)

  vpc_id     = "${var.vpc_id}"
  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[index(var.vpc_db_subnets, each.key)]


  tags = {
    Name = "Publicsubet_${index(var.vpc_db_subnets, each.key)}"
    "kubernetes.io/cluster/eks" = "shared"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.vpc_private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.vpc_public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "db" {
  count = length(var.vpc_db_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

output "vpc_id"{
    value ="${aws_vpc.nonprod.id}"
}
