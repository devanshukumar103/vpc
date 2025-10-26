# outputs.tf in network project

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.myvpc.id
}

output "public_subnet" {
  description = "List of public subnet IDs"
  # This handles either count or for_each
  value       = [for s in aws_subnet.public_subnets : s.id]
}
#