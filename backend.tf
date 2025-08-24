terraform {
  backend "s3" {
    bucket = "deva-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
