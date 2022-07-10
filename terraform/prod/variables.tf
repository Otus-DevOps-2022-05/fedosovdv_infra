variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  default     = "ru-central1-a"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable service_account_key_file {
  description = "key.json"
}
variable private_key_path {
  description = "ssh_key"
}
variable app_disk_image {
  description = "Disk image for reddit app"
}
variable db_disk_image {
  description = "Disk image for reddit db"
}
# variable app_deploy {
#   description = "Run deploy apps?"
#   default     = "false"
# }
