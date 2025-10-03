terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateinbackend"
    container_name       = "tfstate"
    key                  = "tw-terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "tw-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "tw${terraform.workspace}-vpc"
    Environment = terraform.workspace
  }
}

resource "aws_internet_gateway" "tw-igw" {
  vpc_id = aws_vpc.tw-vpc.id

  tags = {
    Name = "tw${terraform.workspace}-igw"
  }
}

resource "aws_route_table" "tw-public-crt" {
  vpc_id = aws_vpc.tw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tw-igw.id
  }

  tags = {
    Name = "tw-public-crt"
  }
}

resource "aws_security_group" "tw-sg" {
  vpc_id      = aws_vpc.tw-vpc.id
  name        = "tw${terraform.workspace}-sg"
  description = "Security group for Terraform dev workspace"

  tags = {
    Name = "tw${terraform.workspace}-sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.tw-sg.id
  description       = "Allow HTTP traffic"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.tw-sg.id
  description       = "Allow HTTPS traffic"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tw-sg.id
  description       = "Allow SSH traffic"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.tw-sg.id
  description       = "Allow all egress traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_subnet" "tw-public-subnet-1" {
  vpc_id                  = aws_vpc.tw-vpc.id
  cidr_block              = var.public-subnet-1
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "tw${terraform.workspace}-public-subnet"
  }
}

resource "aws_subnet" "tw-private-subnet-1" {
  vpc_id            = aws_vpc.tw-vpc.id
  cidr_block        = var.private-subnet-1
  availability_zone = var.availability_zone

  tags = {
    Name = "tw${terraform.workspace}-private-subnet"
  }
}

resource "aws_route_table_association" "tw-rt-subnet" {
  subnet_id      = aws_subnet.tw-public-subnet-1.id
  route_table_id = aws_route_table.tw-public-crt.id
}

resource "aws_instance" "tw-ec2" {
  instance_type          = var.instance_type
  ami                    = var.ami_id
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.tw-sg.id]
  subnet_id              = aws_subnet.tw-public-subnet-1.id
  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
    os_type = terraform.workspace == "dev" ? "amazon" : "ubuntu"
  }))

  tags = {
    Name        = "tw${terraform.workspace}-ec2"
    Environment = terraform.workspace

  }

}