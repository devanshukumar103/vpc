terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "prod/myapp/terraform.tfstate"
    region = "us-east-1"
  }
}
