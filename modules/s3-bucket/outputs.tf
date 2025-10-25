# modules/s3-bucket/outputs.tf
output "bucket_id" {
  description = "The ID (name) of the S3 bucket."
  value       = aws_s3_bucket_acl.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket_acl.this.arn
}

