terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.17.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.37.0"
    }
  }
}
