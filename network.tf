resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    terraform = "true"
    Name = "vpc1"
  }
}

# resource "aws_subnet" "publicsubnet" {
#   vpc_id = aws_vpc.myvpc.id
#   cidr_block = "10.0.1.0/24"
#   tags = {
#     terraform = "true"
#     Name = "subnet1"
#   }

# }

# ---------------------------
# Public Subnets (Loop)
# ---------------------------
locals {
  public_subnets = {
    public-1 = "10.101.12.0/25"
    public-2 = "10.101.12.128/25"
    public-3 = "10.101.13.0/25"
  }

  private_subnets = {
    private-1 = "10.101.0.0/22"
    private-2 = "10.101.4.0/22"
    private-3 = "10.101.8.0/22"
  }

  database_subnets = {
    database-1 = "10.101.13.128/25"
    database-2 = "10.101.14.0/25"
    database-3 = "10.101.14.128/25"
  }
}

# ---------------------------
# Public Subnets
# ---------------------------
resource "aws_subnet" "public_subnets" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = each.value
  # map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Type      = "public"
    Terraform = "true"
  }
}

# ---------------------------
# Private Subnets
# ---------------------------
resource "aws_subnet" "private_subnets" {
  for_each   = local.private_subnets
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = each.value

  tags = {
    Name      = each.key
    Type      = "private"
    Terraform = "true"
  }
}

# ---------------------------
# Database Subnets
# ---------------------------
resource "aws_subnet" "database_subnets" {
  for_each   = local.database_subnets
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = each.value

  tags = {
    Name      = each.key
    Type      = "database"
    Terraform = "true"
  }
}


# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.1.2"

#   name = "dev-vpc"
#   cidr = "10.101.0.0/16"

#   azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

#   # --- 3 Public Subnets ---
#   public_subnets = [
#     "10.101.12.0/25",
#     "10.101.12.128/25",
#     "10.101.13.0/25"
#   ]

#   # --- 3 Private Subnets ---
#   private_subnets = [
#     "10.101.0.0/22",
#     "10.101.4.0/22",
#     "10.101.8.0/22"
#   ]

#   # --- 3 Database Subnets ---
#   database_subnets = [
#     "10.101.13.128/25",
#     "10.101.14.0/25",
#     "10.101.14.128/25"
#   ]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "Tier" = "Public"
#   }

#   private_subnet_tags = {
#     "Tier" = "Private"
#   }

#   database_subnet_tags = {
#     "Tier" = "Database"
#   }

#   tags = {
#     Environment = "dev"
#     Project     = "vpc-setup"
#   }
# }

