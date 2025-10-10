# resource "aws_vpc" "myvpc" {
#   cidr_block = "10.101.0.0/16"
#   tags = {
#     terraform = "true"
#     Name = "vpc02"
#   }
# }

# ##########################
# # Subnets (for RDS)
# ##########################
# resource "aws_subnet" "public_subnet_1" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.101.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-1"
#   }
# }

# resource "aws_subnet" "public_subnet_2" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.101.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-2"
#   }
# }

# ##########################
# # DB Subnet Group
# ##########################
# resource "aws_db_subnet_group" "deva_subnet_group" {
#   name       = "deva-db-subnet-group"
#   subnet_ids = [
#     aws_subnet.public_subnet_1.id,
#     aws_subnet.public_subnet_2.id
#   ]

#   tags = {
#     Name = "deva-db-subnet-group"
#   }
# }

# ##########################
# # Security Group for MySQL
# ##########################
# resource "aws_security_group" "rds_sg" {
#   name        = "deva-db-sg"
#   description = "Allow MySQL access"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress {
#     description = "MySQL Access"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # ⚠️ For testing only! Restrict in production.
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "deva-db-sg"
#   }
# }

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
