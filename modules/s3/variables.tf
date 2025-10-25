variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
  validation {
    condition     = length(var.bucket_name) <= 60
    error_message = "Bucket name cannot exceed 60 characters."
  }
}

variable "enable_versioning" {
  type        = bool
  default     = false
  description = "Enable versioning for the bucket"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "Custom tags to apply to the bucket"
}
