variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
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
