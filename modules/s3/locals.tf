locals {
  # Standardized base tags
  base_tags = {
    ManagedBy   = "Terraform"
    Application = "S3-Module"
    CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
  }

  # Simulate a Terraform "function" by merging
  function_tags = merge(local.base_tags, var.custom_tags)
}
