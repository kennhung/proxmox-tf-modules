# Required Variables

variable "node_name" {
  type        = string
  description = "The name of the Proxmox node to use."
}

variable "vm_id" {
  type        = number
  description = "The VM ID to use for the new container."
}

variable "hostname" {
  type        = string
  description = "The hostname for the HAProxy server container."
}

variable "default_network" {
  type = object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = string
  })
  description = "The default network configuration for the new container."
}

variable "template_file_id" {
  type        = string
  description = "The ID of the Proxmox LXC template file to use."
}

variable "frontends" {
  type = list(object({
    name    = string
    bind    = string
    mode    = optional(string, "http")
    backend = string
    options = optional(list(string), [])
  }))
  description = "HAProxy frontend definitions."
}

variable "backends" {
  type = list(object({
    name    = string
    mode    = optional(string, "http")
    balance = optional(string, "roundrobin")
    options = optional(list(string), [])
    servers = list(object({
      name    = string
      address = string
      options = optional(list(string), ["check"])
    }))
  }))
  description = "HAProxy backend definitions."
}

# Optional Variables

variable "description" {
  type        = string
  description = "The description for the HAProxy server container."
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to assign to the new container."
  default     = null
}

variable "no_default_tags" {
  type        = bool
  description = "Whether to exclude default tags."
  default     = null
}

variable "pool_id" {
  type        = string
  description = "The ID of the Proxmox pool to assign the new container to."
  default     = null
}

variable "started" {
  type        = bool
  description = "Whether the container is started."
  default     = null
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to assign to the new container."
  default     = null
}

variable "memory_mb" {
  type        = number
  description = "The amount of memory (in MB) to assign to the new container."
  default     = null
}

variable "additional_networks" {
  type = list(object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = optional(string, "")
  }))
  description = "A list of additional network configurations for the new container."
  default     = null
}

variable "bootdisk" {
  type = object({
    datastore_id = optional(string, "local-lvm")
    size         = optional(number, 8)
  })
  description = "The boot disk configuration for the new container."
  default     = null
}

variable "password" {
  type        = string
  sensitive   = true
  description = "The password for the root user in the new container."
  default     = null
}

variable "ssh_keys" {
  type        = list(string)
  description = "A list of SSH public keys to add to the root user in the new container."
  default     = null
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS server addresses to assign to the new container."
  default     = null
}

variable "ssh_private_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "SSH private key for connecting to the container to configure HAProxy."
}

variable "ssh_user" {
  type        = string
  default     = "root"
  nullable    = false
  description = "SSH user for Ansible to connect with. Defaults to root for LXC containers."
}
