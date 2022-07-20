

resource "yandex_compute_instance" "db" {
  name = "reddit-db"
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  # }
  #
  # resource "null_resource" "db" {
  #   count = var.app_deploy ? 1 : 0
  #   triggers = {
  #     cluster_instance_ids = yandex_compute_instance.db.id
  #   }
  #
  # connection {
  #   type        = "ssh"
  #   host        = yandex_compute_instance.db.network_interface[0].nat_ip_address
  #   user        = "ubuntu"
  #   agent       = false
  #   private_key = file(var.private_key_path)
  # }
  #
  # provisioner "file" {
  #   content = templatefile("${path.module}/files/mongod.conf.tpl", {
  #     mongo_ip = yandex_compute_instance.db.network_interface.0.ip_address
  #   })
  #   destination = "/tmp/mongodb.conf"
  # }
  #
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mv -f /tmp/mongodb.conf /etc/mongodb.conf",
  #     "sudo systemctl restart mongodb",
  #   ]
  # }

}
