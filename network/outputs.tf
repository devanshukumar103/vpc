# outputs.tf in network project

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.myvpc.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  # This handles either count or for_each
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private_subnets : s.id]
}
