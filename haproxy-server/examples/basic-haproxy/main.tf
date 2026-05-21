variable "node_name" {}

variable "vm_id" {}

variable "bridge" {}

variable "address" {}

variable "gw" {}

variable "template_file_id" {}

variable "password" {
  sensitive = true
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

module "haproxy_server" {
  source = "../.."

  node_name        = var.node_name
  vm_id            = var.vm_id
  hostname         = "haproxy"
  template_file_id = var.template_file_id
  password         = var.password

  ssh_keys        = [tls_private_key.ssh_key.public_key_openssh]
  ssh_private_key = tls_private_key.ssh_key.private_key_pem

  default_network = {
    bridge_name  = var.bridge
    ipv4_address = var.address
    ipv4_gateway = var.gw
  }

  frontends = [
    {
      name    = "http"
      bind    = "*:80"
      backend = "web"
    },
  ]

  backends = [
    {
      name = "web"
      servers = [
        { name = "web1", address = "192.168.1.10:80" },
        { name = "web2", address = "192.168.1.11:80" },
      ]
    },
  ]
}

output "haproxy_ip" {
  value = module.haproxy_server.ipv4_address
}
