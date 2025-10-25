# resource "aws_vpc" "myvpc" {
#    cidr_block = "10.101.0.0/16"
#    enable_dns_support   = true
#    enable_dns_hostnames = true
#    tags = {
#      terraform = "true"
#      Name = "vpc02"
#    }
#  }
 
# # ---------------------------
# # Public Subnets (Loop)
# # ---------------------------
#  locals {
#    public_subnets = {
#      public-01 = "10.101.12.0/25"
#      public-02 = "10.101.12.128/25"
#      public-03 = "10.101.13.0/25"
#    }

#    private_subnets = {
#      private-01 = "10.101.0.0/22"
#      private-02 = "10.101.4.0/22"
#      private-03 = "10.101.8.0/22"
#    }

#    database_subnets = {
#      database-01 = "10.101.13.128/25"
#      database-02 = "10.101.14.0/25"
#      database-03 = "10.101.14.128/25"
#    }
#  }

#  # ---------------------------
#  # Public Subnets
#  # ---------------------------
#  resource "aws_subnet" "public_subnets" {
#    for_each                = local.public_subnets
#    vpc_id                  = aws_vpc.myvpc.id
#    cidr_block              = each.value
#    # map_public_ip_on_launch = true

#    tags = {
#      Name      = each.key
#      Type      = "public"
#      Terraform = "true"
#    }
#  }

# # # ---------------------------
# # # Private Subnets
# # # ---------------------------
#  resource "aws_subnet" "private_subnets" {
#    for_each   = local.private_subnets
#    vpc_id     = aws_vpc.myvpc.id
#    cidr_block = each.value

#    tags = {
#      Name      = each.key
#      Type      = "private"
#      Terraform = "true"
#    }
#  }

# # # ---------------------------
# # # Database Subnets
# # # ---------------------------
#  resource "aws_subnet" "database_subnets" {
#    for_each   = local.database_subnets
#    vpc_id     = aws_vpc.myvpc.id
#    cidr_block = each.value

#    tags = {
#      Name      = each.key
#      Type      = "database"
#      Terraform = "true"
#    }
#  }

# #####################

# # ---------------------------
# # Internet Gateway
# # ---------------------------
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name      = "vpc02-igw"
#     Terraform = "true"
#   }
# }

# # ---------------------------
# # Public Route Table
# # ---------------------------
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name      = "public-rt"
#     Terraform = "true"
#   }
# }

# # ---------------------------
# # Associate Public Subnets with Route Table
# # ---------------------------
# resource "aws_route_table_association" "public_associations" {
#   for_each       = aws_subnet.public_subnets
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.public_rt.id
# }

# ###############

# # ---------------------------
# # Public NACL
# # ---------------------------
# resource "aws_network_acl" "public_nacl" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name      = "public-nacl"
#     Terraform = "true"
#   }
# }

# resource "aws_network_acl_rule" "public_inbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_rule" "public_outbound" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 100
#   egress         = true
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# # Associate NACL with public subnets
# resource "aws_network_acl_association" "public_nacl_assoc" {
#   for_each       = aws_subnet.public_subnets
#   subnet_id      = each.value.id
#   network_acl_id = aws_network_acl.public_nacl.id
# }

# # ---------------------------
# # Private NACL
# # ---------------------------
# resource "aws_network_acl" "private_nacl" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name      = "private-nacl"
#     Terraform = "true"
#   }
# }

# resource "aws_network_acl_rule" "private_inbound" {
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "10.101.0.0/16"
# }

# resource "aws_network_acl_rule" "private_outbound" {
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number    = 100
#   egress         = true
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_association" "private_nacl_assoc" {
#   for_each       = aws_subnet.private_subnets
#   subnet_id      = each.value.id
#   network_acl_id = aws_network_acl.private_nacl.id
# }

# # ---------------------------
# # Database NACL
# # ---------------------------
# resource "aws_network_acl" "database_nacl" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name      = "database-nacl"
#     Terraform = "true"
#   }
# }

# resource "aws_network_acl_rule" "database_inbound" {
#   network_acl_id = aws_network_acl.database_nacl.id
#   rule_number    = 100
#   egress         = false
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "10.101.0.0/16"
# }

# resource "aws_network_acl_rule" "database_outbound" {
#   network_acl_id = aws_network_acl.database_nacl.id
#   rule_number    = 100
#   egress         = true
#   protocol       = "-1"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_association" "database_nacl_assoc" {
#   for_each       = aws_subnet.database_subnets
#   subnet_id      = each.value.id
#   network_acl_id = aws_network_acl.database_nacl.id
# }

# #############################

# # ---------------------------
# # Security Group
# # ---------------------------
# resource "aws_security_group" "public_sg" {
#   name        = "public-sg"
#   description = "Allow SSH and HTTP"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress {
#     description = "SSH from anywhere"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name      = "public-sg"
#     Terraform = "true"
#   }
# }


# # ---------------------------
# # DB Subnet Group (uses your database subnets)
# # ---------------------------
# resource "aws_db_subnet_group" "deva_subnet_group" {
#   name       = "deva-db-subnet-group"
#   subnet_ids = [for subnet in aws_subnet.database_subnets : subnet.id]

#   tags = {
#     Name      = "deva-db-subnet-group"
#     Terraform = "true"
#   }
# }


# # ---------------------------
# # RDS Security Group (for MySQL access)
# # ---------------------------
# resource "aws_security_group" "rds_sg" {
#   name        = "rds-sg"
#   description = "Allow MySQL access from within VPC"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress {
#     description = "Allow MySQL from inside the VPC"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["10.101.0.0/16"]  # VPC CIDR
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name      = "rds-sg"
#     Terraform = "true"
#   }
# }


