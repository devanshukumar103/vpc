# terraform {
#   backend "s3" {
#     bucket = "deva-terraform-state"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket                = "terraform-states-deva"
#     dynamodb_table          = "use_lockfile"
#     encrypt                 = true
#     key                     = "network/state.tfstate"
#     region                  = "eu-central-1"
#   }
# }


terraform {
  backend "s3" {
    bucket         = "deva-terraform-state"   # Make sure this bucket already exists
    key            = "network/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true  # replaces dynamodb_table (deprecated)
  }
}