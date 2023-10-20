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

variable "app_instance_template_parameters" {
  description = "Parameters for the app instance template"
  type = object({
    name         = string # Name of the instance template
    machine_type = string # Machine type for the instance template
    image        = string # Image for the boot disk
    network      = string # Network for the network interface
    ssh_user = string # SSH username for connecting to the instance
    public_ssh_key_file_path = string # Path to the ssh public key on the local machine
    tags = list(string) # Tags for the instance template
  })
}

variable "instance_template_tags" {
  description = "Tags for the instance template"
  type        = list(string)
  default     = ["allow-health-check"]
}
