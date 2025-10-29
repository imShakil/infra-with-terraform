resource "tls_private_key" "xfusion-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "xfusion-kp" {
  key_name   = "xfusion-kp"
  public_key = tls_private_key.xfusion-key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.xfusion-key.private_key_pem
  filename        = "xfusion-kp.pem"
  file_permission = "0400"
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "kk_instance" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.xfusion-kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]
  tags = {
    Name = "xfusion-ec2"
  }
}
