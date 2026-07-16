terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform-Lab_VPC"
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.lab_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Terraform-Public-Subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.lab_vpc.id
    tags = {
        Name = "Terraform-IGW"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.lab_vpc.id
    tags = {
        Name = "Terraform-Public-RT"
    }
}

resource "aws_route" "internet_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}