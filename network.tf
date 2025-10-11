resource "aws_vpc" "myvpc" {
   cidr_block = "10.101.0.0/16"
   enable_dns_support   = true
   enable_dns_hostnames = true
   tags = {
     terraform = "true"
     Name = "vpc02"
   }
 }

# ---------------------------
# Public Subnets (Loop)
# ---------------------------
 locals {
   public_subnets = {
     public-01 = "10.101.12.0/25"
     public-02 = "10.101.12.128/25"
     public-03 = "10.101.13.0/25"
   }

   private_subnets = {
     private-01 = "10.101.0.0/22"
     private-02 = "10.101.4.0/22"
     private-03 = "10.101.8.0/22"
   }

   database_subnets = {
     database-01 = "10.101.13.128/25"
     database-02 = "10.101.14.0/25"
     database-03 = "10.101.14.128/25"
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

# # ---------------------------
# # Private Subnets
# # ---------------------------
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

# # ---------------------------
# # Database Subnets
# # ---------------------------
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



