terraform {
   backend "s3" {
     bucket         = "deva-tfstate"   # Make sure this bucket already exists
     key            = "network/state.tfstate"
     region         = "us-east-1"
     encrypt        = true
     use_lockfile   = true  # replaces dynamodb_table (deprecated)
   }
 }

