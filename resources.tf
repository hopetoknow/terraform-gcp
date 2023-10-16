resource "google_compute_instance" "app" {
  name         = var.app_instance_parameters.name
  machine_type = var.app_instance_parameters.machine_type
  zone         = var.app_instance_parameters.zone

  boot_disk {
    initialize_params {
      image = var.app_instance_parameters.image
    }
  }

  network_interface {
    network = var.app_instance_parameters.network
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.app_instance_parameters.ssh_user}:${file(var.app_instance_parameters.public_ssh_key_file_path)}"
  }
}
