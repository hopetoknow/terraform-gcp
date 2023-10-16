variable "gcp_credentials" {
  type        = string
  description = "Path to the Google Cloud JSON credentials file."
}

variable "gcp_project_id" {
  type        = string
  description = "Google Cloud project id ."
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud region for resources."
}

variable "app_instance_parameters" {
  description = "Parameters for the app instance"
  type = object({
    name         = string # Name of the instance
    machine_type = string # Machine type for the instance
    zone         = string # Zone for the instance
    image        = string # Image for the boot disk
    network      = string # Network for the network interface
    ssh_user = string # SSH username for connecting to the instance
    public_ssh_key_file_path = string # Path to the ssh public key on the local machine
  })
}
