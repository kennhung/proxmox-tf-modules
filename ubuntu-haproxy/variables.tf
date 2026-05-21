variable "node_name" {
  type        = string
  description = "Name of the Proxmox node where the VM will be created."
}

variable "vmid" {
  type        = number
  description = "Proxmox VMID for the virtual machine."
}

variable "name" {
  type        = string
  description = "Name of the Proxmox VM. Defaults to 'ubuntu-haproxy'."
  default     = "ubuntu-haproxy"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores for the virtual machine. Defaults to 2."
  default     = 2
}

variable "memory_mb" {
  type        = number
  description = "Amount of memory (in MB) for the virtual machine. Defaults to 2048."
  default     = 2048
}

variable "network_bridge" {
  type        = string
  description = "Name of the network bridge to connect the VM to."
}

variable "ipv4_address" {
  type        = string
  description = "IPv4 address for the VM. (In CIDR notation)"
}

variable "ipv4_gateway" {
  type        = string
  description = "IPv4 gateway for the VM."
}

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers for the VM. Defaults to node's DNS servers."
  default     = []
}

variable "cloud_image_datastore_id" {
  type        = string
  description = "ID of the datastore where the cloud image will be stored. Defaults to 'local'."
  default     = "local"
}

variable "cloud_image_file_id" {
  type        = string
  description = "ID of the cloud image file to be used for the VM. If not provided, the module will automatically download ubuntu 24.04 cloud image."
  default     = ""
}

variable "bootdisk_datastore_id" {
  type        = string
  description = "ID of the datastore where the boot disk will be stored."
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "ID of the datastore for cloud-init configuration. Defaults to the same as the boot disk."
  default     = ""
}

variable "ubuntu_password" {
  type        = string
  description = "Password for the Ubuntu VM. If not provided, a random password will be generated."
  default     = ""
}
