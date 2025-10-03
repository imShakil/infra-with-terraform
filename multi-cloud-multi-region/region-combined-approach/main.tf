provider "aws" {

}

provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-central"
  region = "eu-central-1"
}

resource "aws_s3_bucket" "bkt-us" {
  bucket   = "imshakil-bkt-us"
  provider = aws.us-east
}

resource "aws_s3_bucket" "bkt-eu" {
  bucket   = "imshakil-bkt-eu"
  provider = aws.eu-central
}

output "bkt-us-id" {
  value = aws_s3_bucket.bkt-us.id
}

output "bkt-eu-id" {
  value = aws_s3_bucket.bkt-eu.id
}
