provider "aws" {
    region = "ap-southeast-1" 
}

resource "aws_instance" "name" {
    ami = "ami-088d74defe9802f14"
    instance_type = "t2.micro"
    tags = {
        Name = "terraform"
    }
}
