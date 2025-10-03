terraform {
  backend "s3" {
    bucket         = "imshakil-bkt-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }

}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "tf-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf-vpc"
  }
}
