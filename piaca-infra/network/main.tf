provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "key" {
  key_name   = "piaca-key"
  public_key = file("C:/Users/estev/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "ec2_sg" {
  name = "piaca-ec2-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.6.248.124/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name = "piaca-rds-sg"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}