# ---------------------------
# DB Subnet Group (uses your database subnets)
# ---------------------------
resource "aws_db_subnet_group" "deva_subnet_group" {
  name       = "deva-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.database_subnets : subnet.id]

  tags = {
    Name      = "deva-db-subnet-group"
    Terraform = "true"
  }
}

# ---------------------------
# RDS Security Group (for MySQL access)
# ---------------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access from within VPC"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow MySQL from inside the VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.101.0.0/16"]  # VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "rds-sg"
    Terraform = "true"
  }
}


