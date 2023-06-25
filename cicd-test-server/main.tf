resource "aws_instance" "flask" {
  ami = "ami-0a0064415cdedc552"
  instance_type = "t3.micro"
  key_name = "cicd_key"

  user_data = templatefile("${path.module}/user-data.sh",{})

  associate_public_ip_address = true

  security_groups = [aws_security_group.flask_sg.name]
  tags = {
    Name = "flask"
  }
}

resource "aws_security_group" "flask_sg" {
  name = "flask_sg"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = [local.myip]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [local.myip]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "cicd_key"
  public_key = tls_private_key.example.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOF
      echo "${tls_private_key.example.private_key_pem}" > cicd_key.pem
      chmod 400 cicd_key.pem
    EOF
  }
  provisioner "local-exec" {
    when = destroy
    command = <<-EOF
      rm cicd_key.pem
    EOF
  }
}
