terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# provider "aws" {
#   region = "ap-south-1"
# }

locals {
  # Define workspace-aware environment
  environment = terraform.workspace
}

# Define multiple S3 buckets
variable "buckets" {
  default = {
    app1 = {
      bucket_name       = "myapp1-ashokkumar3398"
      enable_versioning = true
      tags = {
        Owner = "Ashok"
      }
    }
    app2 = {
      bucket_name       = "myapp2-ashokkumar3398"
      enable_versioning = false
      tags = {
        Owner = "Team-Cloud"
      }
    }
  }
}

# Create S3 buckets dynamically using for_each
module "s3_buckets" {
  source = "./modules/s3"

  for_each          = var.buckets
  bucket_name       = each.value.bucket_name
  enable_versioning = each.value.enable_versioning
  custom_tags       = merge(each.value.tags, { Environment = local.environment })
}
