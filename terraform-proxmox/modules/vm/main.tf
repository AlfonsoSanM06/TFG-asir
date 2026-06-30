resource "proxmox_virtual_environment_vm" "this" {
  vm_id         = var.vm_id
  name          = var.vm_name
  description   = var.vm_description
  node_name     = var.proxmox_node
  on_boot       = true
  tags          = concat(["terraform"], var.tags)
  scsi_hardware = "virtio-scsi-single"

  # Clonación desde plantilla Cloud-Init
  clone {
    vm_id = var.template_vm_id
    full  = false
  }

  # Agente QEMU
  agent {
    enabled = true
  }

  # Arranque
  boot_order = ["scsi0"]

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.ram_mb
    floating  = var.balloon_mb
  }

  # Disco OS
  disk {
    datastore_id = var.storage_pool
    size         = var.disk_size_gb
    interface    = "scsi0"
    discard      = "on" # TRIM/UNMAP para thin-provisioning.
    ssd          = true
    iothread     = true
  }

  # Red — VLAN tag aplicado en el puerto virtual
  network_device {
    model   = "virtio"
    bridge  = var.network_bridge
    vlan_id = var.network_vlan > 0 ? var.network_vlan : null
  }

  # Cloud-Init
  initialization {
    datastore_id = var.storage_pool

    ip_config {
      ipv4 {
        address = "${var.ip_address}/${var.cidr_prefix}"
        gateway = var.gateway
      }
    }

    dns {
      servers = split(" ", var.dns_servers)
    }

    user_account {
      username = var.ci_user
      keys     = [var.ci_ssh_key]
    }
  }

  # Ciclo de vida
  lifecycle {
    ignore_changes = [
      description,
      tags,
      network_device, # Evita drift por cambio de MAC autogenerada.
    ]
  }
}
