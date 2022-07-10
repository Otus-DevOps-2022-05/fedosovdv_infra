variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable mongo_ip {
  description = "Internal Mongodb IP"
  default     = "127.0.0.1"
}
variable private_key_path {
  description = "ssh_key"
}
