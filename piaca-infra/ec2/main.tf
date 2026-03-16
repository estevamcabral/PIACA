provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "ec2_sg" {
  name = "piaca-ec2-sg"
}

data "aws_key_pair" "key" {
  key_name = "piaca-key"
}

resource "aws_instance" "ec2" {

  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  key_name = data.aws_key_pair.key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    data.aws_security_group.ec2_sg.id
  ]

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -L https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
yum install -y git
cd /home/ec2-user
git clone https://github.com/estevamcabral/PIACA.git app
cd app
docker-compose up -d
EOF

  tags = {
    Name = "piaca-test"
  }
}

output "ip" {
  value = aws_instance.ec2.public_ip
}