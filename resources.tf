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

  tags = var.app_instance_parameters.tags

  provisioner "remote-exec" {
    connection {
      type        = var.app_instance_parameters.connection_type
      user = var.app_instance_parameters.connection_user
      private_key = file(var.app_instance_parameters.private_ssh_key_file_path)
      host     = self.network_interface.0.access_config.0.nat_ip
    }

    script = "scripts/wait_for_instance.sh"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i '${google_compute_instance.app.network_interface.0.access_config.0.nat_ip},' test.yml --private-key=${var.app_instance_parameters.private_ssh_key_file_path}"
  }
}
