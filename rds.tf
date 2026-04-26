# 1. Declare the variable (This fixes the "undeclared input variable" error)
variable "db_password" {
  description = "The password for the MySQL RDS instance"
  type        = string
  sensitive   = true
}
# 2. Security Group (Firewall)
resource "aws_security_group" "rds_sg" {
  name        = "mysql-rds-sg"
  description = "Allow MySQL traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier           = "clean-mysql-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro" 
  allocated_storage    = 20
  storage_type         = "gp2"

  db_name              = "myappdb"
  username             = "admin"
  password             = var.db_password # References the variable below
  
  multi_az             = false           # Disables High Availability (saves cost)
  publicly_accessible  = true            # Set to false if staying inside a VPC
  skip_final_snapshot  = true            # Allows 'terraform destroy' without errors
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# 4. Output the connection string
output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

