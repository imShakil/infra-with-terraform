output "vpc_id" {
  value = aws_vpc.tw-vpc.id
}

output "public-subnet-cidr" {
  value = aws_subnet.tw-public-subnet-1.cidr_block
}

output "security_group_id" {
  value = aws_security_group.tw-sg.id
}

output "instance_id" {
  value = aws_instance.tw-ec2.id
}

output "instance-public-ip" {
  value = aws_instance.tw-ec2.public_ip
}

output "instance-public-dns" {
  value = aws_instance.tw-ec2.public_dns
}
