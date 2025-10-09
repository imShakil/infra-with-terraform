terraform {
    backend "s3" {
        bucket         = "imshakil-bkt-tfstate"
        key            = "terraform.tfstate"
        region         = "ap-southeast-1"
        use_lockfile   = true
    }
}


provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.10.0.0/16"
}