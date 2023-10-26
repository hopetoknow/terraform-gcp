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
