variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "enable_versioning" {
  type        = bool
  default     = false
  description = "Enable versioning on the S3 bucket"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "Custom user-defined tags"
}
