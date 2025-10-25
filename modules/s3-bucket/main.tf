# # modules/s3-bucket/main.tf
# resource "aws_s3_bucket" "this" {
#   bucket = var.bucket_name
#   #acl = var.acl

#   tags = var.tags

#   # Enable versioning if specified
#   dynamic "versioning" {
#     for_each = var.enable_versioning ? [1] : []
#     content {
#       enabled = true
#     }
#   }

#   # Add other S3 bucket configurations as needed (e.g., server-side encryption, lifecycle rules)
# }
