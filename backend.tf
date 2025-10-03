# terraform {
#   backend "s3" {
#     bucket = "deva-terraform-state"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }

terraform {
  backend "s3" {
    bucket                = "terraform-states-deva"
    dynamodb_table          = "terraform-state-lock-init"
    encrypt                 = true
    key                     = "network/state.tfstate"
    region                  = "eu-central-1"
  }
}
