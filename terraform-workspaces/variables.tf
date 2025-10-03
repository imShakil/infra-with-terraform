variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "AWS region"
}

variable "availability_zone" {
  default     = "ap-southeast-1a"
  type        = string
  description = "AWS availability_zone"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR block"
}

variable "public-subnet-1" {
  default     = "10.0.1.0/24"
  type        = string
  description = "Public subnet 1"
}

variable "private-subnet-1" {
  default     = "10.0.2.0/24"
  type        = string
  description = "Priavte subnet 1"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "EC2 instance type"
}

variable "ami_id" {
  default     = "ami-088d74defe9802f14"
  type        = string
  description = "EC2 AMI ID"
}

variable "key_pair" {
  default     = "shakil-dev-pub"
  type        = string
  description = "EC2 SSH key pair name"
}
