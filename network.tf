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
# # Internet Gateway
# ##########################
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id
#   tags = {
#     Name = "vpc02-igw"
#   }
# }

# ##########################
# # Route Table + Associations
# ##########################
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "vpc02-public-rt"
#   }
# }

# ##########################
# # Associate Subnets with Route Table
# ##########################
# resource "aws_route_table_association" "rt_assoc_1" {
#   subnet_id      = aws_subnet.public_subnet_1.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "rt_assoc_2" {
#   subnet_id      = aws_subnet.public_subnet_2.id
#   route_table_id = aws_route_table.public_rt.id
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
#     cidr_blocks = ["0.0.0.0/0"] # ⚠️ For testing only
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

# # resource "aws_subnet" "publicsubnet" {
# #   vpc_id = aws_vpc.myvpc.id
# #   cidr_block = "10.0.1.0/24"
# #   tags = {
# #     terraform = "true"
# #     Name = "subnet1"
# #   }

# # }

# ---------------------------
# Public Subnets (Loop)
# ---------------------------
# locals {
#   public_subnets = {
#     public-01 = "10.101.12.0/25"
#     public-02 = "10.101.12.128/25"
#     public-03 = "10.101.13.0/25"
#   }

#   private_subnets = {
#     private-01 = "10.101.0.0/22"
#     private-02 = "10.101.4.0/22"
#     private-03 = "10.101.8.0/22"
#   }

#   database_subnets = {
#     database-01 = "10.101.13.128/25"
#     database-02 = "10.101.14.0/25"
#     database-03 = "10.101.14.128/25"
#   }
# }

# # ---------------------------
# # Public Subnets
# # ---------------------------
# resource "aws_subnet" "public_subnets" {
#   for_each                = local.public_subnets
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = each.value
#   # map_public_ip_on_launch = true

#   tags = {
#     Name      = each.key
#     Type      = "public"
#     Terraform = "true"
#   }
# }

# # ---------------------------
# # Private Subnets
# # ---------------------------
# resource "aws_subnet" "private_subnets" {
#   for_each   = local.private_subnets
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = each.value

#   tags = {
#     Name      = each.key
#     Type      = "private"
#     Terraform = "true"
#   }
# }

# # ---------------------------
# # Database Subnets
# # ---------------------------
# resource "aws_subnet" "database_subnets" {
#   for_each   = local.database_subnets
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = each.value

#   tags = {
#     Name      = each.key
#     Type      = "database"
#     Terraform = "true"
#   }
# }



