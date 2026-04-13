# main.tf
provider "aws" {
  region = "us-east-1"
}

# Security Group for RDS (Allows the App to talk to the DB)
resource "aws_security_group" "rds_sg" {
  name        = "registration-db-sg"
  description = "Allow inbound PostgreSQL traffic"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For a resume, this works; for production, limit to EC2 IP
  }
}

# The PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  db_name              = "registration_db"
  username             = "postgres"
  password             = "mypassword123" # Secure this in Jenkins Credentials later
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# Output the endpoint so Jenkins can use it
output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}