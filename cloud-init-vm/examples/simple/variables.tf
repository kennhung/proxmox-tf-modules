
variable "node_name" {
  type = string
}

variable "vmid" {
  type = number
}

variable "bridge_name" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "ipv4_gateway" {
  type = string
}

variable "bootdisk_datastore_id" {
  type = string
}

variable "bootdisk_file_id" {
  type = string
}

variable "cloud_init_datastore_id" {
  type = string
}

variable "apt_mirror" {
  type        = string
}
