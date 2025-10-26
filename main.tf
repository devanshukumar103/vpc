module "s3_bucket" {
  source = "./modules/s3-bucket"

  bucket_name       = "myapp-dev-bucket-ashokkumar"
  #enable_versioning = true

  custom_tags = {
    Owner       = "Ashok Kumar"
    Environment = "dev"
  }
}
