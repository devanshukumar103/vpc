resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # Apply dynamic tagging logic using the custom tag "function"
  tags = local.final_tags

  # Enable versioning if specified
  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}

locals {
  # Base tags (standard organization tags)
  base_tags = {
    ManagedBy   = "Terraform"
    Application = "S3-Module"
  }

  # Merge base tags with user-provided tags
  final_tags = merge(local.base_tags, var.custom_tags)
}