terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "bkt-eu" {
  bucket = "imshakil-bkt-eu"

  tags = {
    Name        = "EU Bucket"
    Environment = "Test"
    region      = "EU Central"
  }
}

resource "aws_s3_bucket_versioning" "bkt-eu-version" {
  bucket = aws_s3_bucket.bkt-eu.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "id" {
  value = aws_s3_bucket.bkt-eu.id
}

output "url" {
  value = aws_s3_bucket.bkt-eu.bucket_domain_name
}
