provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name = "piaca-sg"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<EOF
#!/bin/bash

apt update -y
apt install -y docker.io docker-compose git

systemctl enable docker
systemctl start docker

cd /home/ubuntu

git clone https://github.com/estevamcabral/PIACA.git app

cd app

docker compose up -d
EOF

  tags = {
    Name = "piaca-test"
  }
}

output "ip" {
  value = aws_instance.ec2.public_ip
}