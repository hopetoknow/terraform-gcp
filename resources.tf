resource "google_compute_instance_template" "app" {
  name = var.app_instance_template_parameters.name
  machine_type = var.app_instance_template_parameters.machine_type

  disk {
    source_image = var.app_instance_template_parameters.image
  }

  network_interface {
    network = var.app_instance_template_parameters.network
  }

  metadata = {
    ssh-keys = "${var.app_instance_template_parameters.ssh_user}:${file(var.app_instance_template_parameters.public_ssh_key_file_path)}"
  }

  region = var.gcp_region
  tags = ["allow-health-check"]
}
