provider "aws" {
  region = "us-east-1"
  # access_key = var.access_key
  # secret_key = var.secret_key
}
#
# module "my_app_s3_bucket" {
#   source = "./modules/s3-bucket" # Path to your module directory

#   bucket_name       = "my-unique-app-bucket-name-ashok"
#   #acl               = "private"
#   enable_versioning = true
#   tags = {
#     Environment = "Development"
#     Project     = "MyApp"
#   }
# }