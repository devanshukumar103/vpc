# ---------------------------
# RDS MySQL Instance (Free Tier)
# ---------------------------
resource "aws_db_instance" "deva_mysql" {
  identifier             = "deva-free-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"     # Free Tier eligible
  allocated_storage      = 20
  storage_type           = "gp2"

  # Master credentials (✅ only ASCII printable allowed, no @ or /)
  username               = "Deva"
  password               = "India123"       # ✅ safe characters

  db_subnet_group_name   = aws_db_subnet_group.deva_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible    = false             # best practice for DBs
  multi_az               = false
  skip_final_snapshot    = true
  deletion_protection    = false
  apply_immediately      = true

  tags = {
    Name      = "deva-free-tier-db"
    Terraform = "true"
  }
}

# ---------------------------
# Outputs
# ---------------------------
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.deva_mysql.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.deva_mysql.port
}

output "rds_username" {
  description = "Master username"
  value       = aws_db_instance.deva_mysql.username
}

output "rds_password" {
  description = "Master password (sensitive)"
  value       = aws_db_instance.deva_mysql.password
  sensitive   = true
}