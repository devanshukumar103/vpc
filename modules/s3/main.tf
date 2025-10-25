resource "aws_s3_bucket" "this" {
  # Append workspace name to bucket for uniqueness
  bucket = lower("${var.bucket_name}-${terraform.workspace}")

  tags = local.function_tags
}

# ------------------------
# Dynamic Block for Versioning
# ------------------------
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# ------------------------
# Example Dynamic Encryption Configuration (optional)
# ------------------------
# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.bucket

#   dynamic "rule" {
#     for_each = var.enable_versioning ? [1] : []
#     content {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }
