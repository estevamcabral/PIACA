provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "rds_sg" {
  name = "piaca-rds-sg"
}

resource "aws_db_instance" "postgres" {

  identifier = "piaca-db"

  engine = "postgres"
  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name  = "piaca_db"
  username = "piaca_user"
  password = "piaca_pass"

  vpc_security_group_ids = [
    data.aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true
}

output "endpoint" {
  value = aws_db_instance.postgres.address
}