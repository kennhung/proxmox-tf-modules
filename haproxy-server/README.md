# haproxy-server

Provisions a Proxmox LXC container and configures HAProxy via an embedded Ansible role.

## Architecture

```
haproxy-server/
├── main.tf           # LXC provisioning + null_resource Ansible trigger
├── variables.tf
├── outputs.tf
├── versions.tf
└── ansible/
    ├── site.yml
    └── roles/haproxy/
        ├── defaults/main.yml   # Tunable defaults (timeouts, maxconn)
        ├── tasks/main.yml      # Install + configure HAProxy
        ├── handlers/main.yml   # Reload on config change
        └── templates/
            └── haproxy.cfg.j2
```

Terraform manages the LXC lifecycle. Once SSH is reachable, a `local-exec` provisioner
writes a temporary vars file and calls `ansible-playbook`. The vars file is cleaned up
after each run. `terraform destroy` removes the LXC container; no Ansible state blocks it.

## Requirements

- `ansible-playbook` available in `$PATH` on the machine running Terraform
- `ssh-agent` and `ssh-add` available (standard OpenSSH client ≥ 7.6) when using `ssh_private_key`
- `ssh_private_key` must be an **unencrypted private key** (no passphrase) — both `ssh-add` and the Terraform SSH connection have no way to supply a passphrase interactively
- `sshpass` available on the Terraform runner when using `password` auth without an SSH key
- OpenSSH ≥ 7.6 on the runner (required for `StrictHostKeyChecking=accept-new`)
- SSH connectivity from the Terraform runner to the LXC container's IP

## Security considerations

This module passes sensitive values (SSH private key material, `ansible_password`) to
`ansible-playbook` via environment variables. On multi-tenant CI runners, environment
variables of a running process may be observable to other processes or users. **Run
`terraform apply` only on trusted, single-tenant machines** (your workstation or a
dedicated CI runner). The private key is loaded into an in-memory `ssh-agent` and never
written to disk.

## SSH user requirements

`ssh_user` (default: `root`) must either **be root** or have **passwordless sudo**. The
Ansible role uses `become: true` to run privileged tasks, but this module does not expose
a `become` password — if the user requires a password to escalate privileges, `apt install`
and `systemctl` commands will fail. For standard Proxmox LXC containers (where the default
SSH user is `root`), no extra configuration is needed.

## Usage

```hcl
resource "tls_private_key" "haproxy_ssh" {
  algorithm = "ED25519"
}

module "haproxy_server" {
  source = "path/to/modules/haproxy-server"

  node_name        = "pve"
  vm_id            = 200
  hostname         = "haproxy-prod"
  template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-1_amd64.tar.zst"

  default_network = {
    bridge_name  = "vmbr0"
    ipv4_address = "192.168.1.200/24"
    ipv4_gateway = "192.168.1.1"
  }

  ssh_keys        = [tls_private_key.haproxy_ssh.public_key_openssh]
  ssh_private_key = tls_private_key.haproxy_ssh.private_key_pem

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
        { name = "web1", address = "10.0.0.1:80" },
        { name = "web2", address = "10.0.0.2:80" },
      ]
    },
  ]
}

output "haproxy_ip" {
  value = module.haproxy_server.ipv4_address
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `node_name` | string | yes | Proxmox node name |
| `vm_id` | number | yes | Container VM ID |
| `hostname` | string | yes | Container hostname |
| `default_network` | object | yes | Bridge, IP, gateway |
| `template_file_id` | string | yes | LXC template file ID |
| `frontends` | list(object) | yes | HAProxy frontend definitions |
| `backends` | list(object) | yes | HAProxy backend definitions |
| `ssh_keys` | list(string) | no | SSH public keys to install on the container (used by Ansible) |
| `ssh_private_key` | string | no | Private key for Ansible SSH |
| `password` | string | no | Password for Ansible SSH (also used for container login) |
| `ssh_user` | string | no | SSH user for Ansible (default: `root`; see SSH user requirements) |

## Outputs

| Name | Description |
|------|-------------|
| `ipv4_address` | Container IPv4 address |

## Tuning HAProxy defaults

Global tuning knobs (`haproxy_global_maxconn`, `haproxy_default_timeout_*`) are defined
in `ansible/roles/haproxy/defaults/main.yml`. Because this module is consumed as a
versioned artifact from a separate repository, these values cannot be changed without
modifying the module source. To override them, fork or patch the module, update
`defaults/main.yml`, and bump the `source` reference in your infra repo.
