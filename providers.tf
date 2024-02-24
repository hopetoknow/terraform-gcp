provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project_id
  region      = var.gcp_region
}

provider "aws" {
  region     = var.aws_parameters.provider_region
  access_key = var.aws_parameters.provider_access_key
  secret_key = var.aws_parameters.provider_secret_key
}
