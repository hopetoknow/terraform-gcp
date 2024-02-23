resource "google_compute_instance" "app" {
  name         = var.instance_parameters.name
  machine_type = var.instance_parameters.machine_type
  zone         = var.instance_parameters.zone

  boot_disk {
    initialize_params {
      image = var.instance_parameters.image
    }
  }

  network_interface {
    network = var.instance_parameters.network
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.instance_parameters.ssh_user}:${file(var.instance_parameters.public_ssh_key_file_path)}"
  }

  tags = var.instance_parameters.tags

  provisioner "remote-exec" {
    connection {
      type        = var.instance_parameters.connection_type
      user = var.instance_parameters.connection_user
      private_key = file(var.instance_parameters.private_ssh_key_file_path)
      host     = self.network_interface.0.access_config.0.nat_ip
    }

    script = "scripts/wait_for_instance.sh"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i '${google_compute_instance.app.network_interface.0.access_config.0.nat_ip},' app.yml --private-key=${var.instance_parameters.private_ssh_key_file_path}"
    working_dir = "${path.module}/ansible" 
  }
}

resource "google_compute_instance_group" "app" {
  name        = var.instance_group_parameters.name
  description = var.instance_group_parameters.description

  instances = [
    google_compute_instance.app.id
  ]

  named_port {
    name = var.instance_group_parameters.named_port_name
    port = var.instance_group_parameters.named_port
  }

  zone = var.instance_group_parameters.zone
}

resource "google_compute_firewall" "app" {
  name          = var.app_firewall_parameters.name
  direction     = var.app_firewall_parameters.direction
  network       = var.app_firewall_parameters.network
  priority      = var.app_firewall_parameters.priority
  source_ranges = var.app_firewall_parameters.source_ranges
  target_tags   = var.app_firewall_parameters.target_tags

  allow {
    ports    = var.app_firewall_parameters.allow_ports
    protocol = var.app_firewall_parameters.allow_protocol
  }
}

resource "google_compute_firewall" "health_check" {
  name          = var.health_check_firewall_parameters.name
  direction     = var.health_check_firewall_parameters.direction
  network       = var.health_check_firewall_parameters.network
  priority      = var.health_check_firewall_parameters.priority
  source_ranges = var.health_check_firewall_parameters.source_ranges
  target_tags   = var.health_check_firewall_parameters.target_tags
  
  allow {
    ports    = var.health_check_firewall_parameters.allow_ports
    protocol = var.health_check_firewall_parameters.allow_protocol
  }
}

resource "google_compute_global_address" "lb" {
  name       = var.global_address_parameters.name
  ip_version = var.global_address_parameters.ip_version
}

resource "google_compute_health_check" "lb" {
  name               = var.health_check_parameters.name
  check_interval_sec = var.health_check_parameters.check_interval_sec
  healthy_threshold  = var.health_check_parameters.healthy_threshold

  http_health_check {
    port               = var.health_check_parameters.port
    port_specification = var.health_check_parameters.port_specification
    proxy_header       = var.health_check_parameters.proxy_header
    request_path       = var.health_check_parameters.request_path
  }

  timeout_sec         = var.health_check_parameters.timeout_sec
  unhealthy_threshold = var.health_check_parameters.unhealthy_threshold
}

resource "google_compute_backend_service" "lb" {
  name                            = var.backend_service_parameters.name
  connection_draining_timeout_sec = var.backend_service_parameters.connection_draining_timeout_sec
  health_checks                   = [google_compute_health_check.lb.id]
  load_balancing_scheme           = var.backend_service_parameters.load_balancing_scheme
  port_name                       = var.backend_service_parameters.port_name
  protocol                        = var.backend_service_parameters.protocol
  session_affinity                = var.backend_service_parameters.session_affinity
  timeout_sec                     = var.backend_service_parameters.timeout_sec

  backend {
    group           = google_compute_instance_group.app.id
    balancing_mode  = var.backend_service_parameters.balancing_mode
    capacity_scaler = var.backend_service_parameters.capacity_scaler
  }
}

resource "google_compute_url_map" "lb" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.lb.id
}

resource "google_compute_target_http_proxy" "lb" {
  name    = var.target_http_proxy_name
  url_map = google_compute_url_map.lb.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.global_forwarding_rule_parameters.name
  ip_protocol           = var.global_forwarding_rule_parameters.ip_protocol
  load_balancing_scheme = var.global_forwarding_rule_parameters.load_balancing_scheme
  port_range            = var.global_forwarding_rule_parameters.port_range
  target                = google_compute_target_http_proxy.lb.id
  ip_address            = google_compute_global_address.lb.id
}
