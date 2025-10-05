terraform {
  backend "s3" {
    bucket = "deva-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# terraform {
#   backend "s3" {
#     bucket                = "terraform-states-deva"
#     dynamodb_table          = "use_lockfile"
#     encrypt                 = true
#     key                     = "network/state.tfstate"
#     region                  = "eu-central-1"
#   }
# }


# terraform {
#   backend "s3" {
#     bucket         = "deva-terraform-state"   # Make sure this bucket already exists
#     key            = "network/state.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     use_lockfile   = true  # replaces dynamodb_table (deprecated)
#   }
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "deva-vpc"
  cidr = "10.101.0.0/16"

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # --- 3 Public Subnets ---
  public_subnets = [
    "10.101.12.0/25",
    "10.101.12.128/25",
    "10.101.13.0/25"
  ]

  # --- 3 Private Subnets ---
  private_subnets = [
    "10.101.0.0/22",
    "10.101.4.0/22",
    "10.101.8.0/22"
  ]

  # --- 3 Database Subnets ---
  database_subnets = [
    "10.101.13.128/25",
    "10.101.14.0/25",
    "10.101.14.128/25"
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "Tier" = "Public"
  }

  private_subnet_tags = {
    "Tier" = "Private"
  }

  database_subnet_tags = {
    "Tier" = "Database"
  }

  tags = {
    Environment = "dev"
    Project     = "vpc-setup"
  }
}

