module "ubuntu_lxc" {
  source = "../ubuntu-lxc"

  node_name        = var.node_name
  vm_id            = var.vm_id
  hostname         = var.hostname
  default_network  = var.default_network
  template_file_id = var.template_file_id

  description         = var.description
  tags                = var.tags
  no_default_tags     = var.no_default_tags
  pool_id             = var.pool_id
  started             = var.started
  cpu_cores           = var.cpu_cores
  memory_mb           = var.memory_mb
  additional_networks = var.additional_networks
  bootdisk            = var.bootdisk
  password            = var.password
  ssh_keys            = var.ssh_keys
  dns_servers         = var.dns_servers

  nesting = true
}

resource "null_resource" "haproxy_ansible" {
  triggers = {
    config_hash = sha256(jsonencode({
      frontends = var.frontends
      backends  = var.backends
    }))
    host = module.ubuntu_lxc.ipv4["eth0"]
    # Intentionally excludes a hash of the ansible/ directory.
    # This module and the infra that consumes it live in separate repos;
    # callers bump the module version (source ref) when they want to pick
    # up role changes, at which point they control whether to taint and
    # reprovision. Auto-detecting local file changes would re-run Ansible
    # on every apply for every consumer, which is not the desired behaviour.
  }

  # Wait for SSH to become available before invoking Ansible.
  connection {
    type        = "ssh"
    host        = module.ubuntu_lxc.ipv4["eth0"]
    user        = var.ssh_user
    private_key = var.ssh_private_key
    password    = var.password
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = ["true"]
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      VARS_FILE=$(mktemp -t haproxy_vars.XXXXXX)
      AGENT_STARTED=0
      trap 'rc=$?; rm -f "$VARS_FILE"; [ "$AGENT_STARTED" = "1" ] && ssh-agent -k > /dev/null; exit $rc' EXIT
      printf '%s' "$HAPROXY_VARS_JSON" > "$VARS_FILE"
      if [ -n "$SSH_PRIVATE_KEY_CONTENT" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        AGENT_STARTED=1
        printf '%s\n' "$SSH_PRIVATE_KEY_CONTENT" | ssh-add -
      fi
      ansible-playbook \
        -i '${self.triggers.host},' \
        --extra-vars "@$VARS_FILE" \
        -u "$ANSIBLE_USER" \
        "${path.module}/ansible/site.yml"
    EOT

    environment = {
      HAPROXY_VARS_JSON = jsonencode(merge(
        {
          haproxy_frontends = var.frontends
          haproxy_backends  = var.backends
        },
        # Only pass ansible_password when no SSH key is provided; if both are
        # set, Ansible would prefer password auth (via sshpass) over the agent.
        var.password != null && var.ssh_private_key == null ? { ansible_password = var.password } : {},
      ))
      ANSIBLE_USER              = var.ssh_user
      SSH_PRIVATE_KEY_CONTENT   = var.ssh_private_key != null ? var.ssh_private_key : ""
      # accept-new trusts a host on first connect but rejects changed keys
      # on subsequent connects; UserKnownHostsFile=/dev/null prevents stale
      # entries on persistent runners from causing spurious failures.
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_SSH_EXTRA_ARGS    = "-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null"
      ANSIBLE_TIMEOUT           = "60"
      ANSIBLE_SSH_RETRIES       = "3"
    }
  }

  depends_on = [module.ubuntu_lxc]
}
