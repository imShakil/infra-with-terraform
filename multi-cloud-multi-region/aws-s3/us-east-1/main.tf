terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bkt-us" {
  bucket = "imshakil-bkt-us"

  tags = {
    Name        = "US Bucket"
    Environment = "Test"
    region      = "US East"
  }
}

resource "aws_s3_bucket_versioning" "bkt-us-version" {
  bucket = aws_s3_bucket.bkt-us.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "id" {
  value = aws_s3_bucket.bkt-us.id
}

output "url" {
  value = aws_s3_bucket.bkt-us.bucket_domain_name
}

