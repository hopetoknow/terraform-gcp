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

variable "instance_parameters" {
  description = "Parameters for the instance"
  type = object({
    name         = string # Name of the instance
    machine_type = string # Machine type for the instance
    zone         = string # Zone for the instance
    image        = string # Image for the boot disk
    network      = string # Network for the network interface
    ssh_user = string # SSH username for connecting to the instance
    public_ssh_key_file_path = string # Path to the ssh public key on the local machine
    private_ssh_key_file_path = string # Path to the ssh private key on the local machine
    connection_type = string # Type of connection
    connection_user = string # User for remote access
    tags = list(string) # Tags for the instance
  })
}

variable "instance_group_parameters" {
  description = "Parameters for the instance group"
  type = object({
    name        = string # Name of the instance group
    description = string # Description of the instance group
    zone        = string # Zone for the instance group
    named_port_name = string # Name of the named port
    named_port = string # Port number for the named port
  })
}

variable "app_firewall_parameters" {
  description = "Parameters for the app firewall"
  type = object({
    name          = string # Name of the firewall rule
    direction     = string # Direction of traffic (e.g., INGRESS or EGRESS)
    network       = string # Network for the firewall rule
    priority      = number # Priority of the firewall rule
    source_ranges = list(string) # List of source IP ranges
    target_tags   = list(string) # List of target tags
    allow_ports = list(string) # List of allowed ports
    allow_protocol = string # Protocol for the allowed traffic
  })
}

variable "health_check_firewall_parameters" {
  description = "Parameters for the health check firewall"
  type = object({
    name          = string # Name of the firewall rule
    direction     = string # Direction of traffic (e.g., INGRESS or EGRESS)
    network       = string # Network for the firewall rule
    priority      = number # Priority of the firewall rule
    source_ranges = list(string) # List of source IP ranges
    target_tags   = list(string) # List of target tags
    allow_ports = list(string) # List of allowed ports
    allow_protocol = string # Protocol for the allowed traffic
  })
}

variable "global_address_parameters" {
  description = "Parameters for the global address"
  type = object({
    name       = string # Name of the global address
    ip_version = string # IP version for the global address
  })
}

variable "health_check_parameters" {
  description = "Parameters for the health check"
  type = object({
    name               = string # Name of the health check
    check_interval_sec = number # Check interval in seconds
    healthy_threshold  = number # Healthy threshold
    port               = number # Port for the health check
    port_specification = string # Port specification (e.g., "USE_FIXED_PORT")
    proxy_header       = string # Proxy header (e.g., "NONE")
    request_path       = string # Request path (e.g., "/")
    timeout_sec         = number # Timeout in seconds
    unhealthy_threshold = number # Unhealthy threshold
  })
}

variable "backend_service_parameters" {
  description = "Parameters for the backend service"
  type = object({
    name                            = string # Name of the backend service
    connection_draining_timeout_sec = number # Connection draining timeout in seconds
    load_balancing_scheme           = string # Load balancing scheme
    port_name                       = string # Port name
    protocol                        = string # Protocol (e.g., HTTP)
    session_affinity                = string # Session affinity (e.g., NONE)
    timeout_sec                     = number # Timeout in seconds
    balancing_mode  = string # Balancing mode
    capacity_scaler = number # Capacity scaler
  })
}

variable "url_map_name" {
  type        = string
  description = "Name of the URL map"
}

variable "target_http_proxy_name" {
  type        = string
  description = "Name of the target HTTP proxy"
}

variable "global_forwarding_rule_parameters" {
  description = "Parameters for the global forwarding rule"
  type = object({
    name                  = string # Name of the forwarding rule
    ip_protocol           = string # IP protocol (e.g., "TCP" or "UDP")
    load_balancing_scheme = string # Load balancing scheme ("INTERNAL" or "EXTERNAL")
    port_range            = string # Port range (e.g., "80-80")
  })
}
