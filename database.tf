
# ##########################
# # RDS MySQL Instance (Free Tier)
# ##########################
# resource "aws_db_instance" "deva_mysql" {
#   identifier             = "deva-free-db"
#   engine                 = "mysql"
#   engine_version         = "8.0"
#   instance_class         = "db.t3.micro"   # Free Tier eligible
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   username               = "Deva"
#   password               = "Indian@123"

#   db_subnet_group_name   = aws_db_subnet_group.deva_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]

#   publicly_accessible    = true
#   multi_az               = false
#   skip_final_snapshot    = true
#   deletion_protection    = false
#   apply_immediately      = true

#   tags = {
#     Name = "deva-free-tier-db"
#   }
# }

# ##########################
# # Outputs
# ##########################
# output "rds_endpoint" {
#   value = aws_db_instance.deva_mysql.endpoint
# }

# output "rds_username" {
#   value = aws_db_instance.deva_mysql.username
# }
