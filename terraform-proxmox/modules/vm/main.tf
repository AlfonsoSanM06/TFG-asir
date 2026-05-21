# =============================================================================
# MODULE vm — main.tf
# Crea una única VM clonando una plantilla Cloud-Init en Proxmox VE.
# Reutilizable para cualquier nodo del proyecto (masters, workers, ldap…).
# Variables → variables.tf | Outputs → outputs.tf
# =============================================================================

resource "proxmox_vm_qemu" "this" {
  vmid        = var.vm_id
  name        = var.vm_name
  desc        = var.vm_description
  target_node = var.proxmox_node

  # ---------------------------------------------------------------------------
  # Clonación desde plantilla Cloud-Init
  # ---------------------------------------------------------------------------
  clone      = var.template_name
  full_clone = true   # Clone completo → independiente de la plantilla.
  agent      = 1      # Habilita qemu-guest-agent (instalado vía Cloud-Init).

  # ---------------------------------------------------------------------------
  # Arranque
  # ---------------------------------------------------------------------------
  boot   = "order=scsi0"
  onboot = true

  # ---------------------------------------------------------------------------
  # Cómputo
  # ---------------------------------------------------------------------------
  cores   = var.cpu_cores
  sockets = var.cpu_sockets
  cpu     = var.cpu_type
  memory  = var.ram_mb
  balloon = var.balloon_mb

  # ---------------------------------------------------------------------------
  # Disco OS — Cloud-Init redimensiona automáticamente al clonar
  # ---------------------------------------------------------------------------
  disk {
    slot     = "scsi0"
    type     = "scsi"
    storage  = var.storage_pool
    size     = "${var.disk_size_gb}G"
    discard  = "on"   # TRIM/UNMAP para thin-provisioning en LVM/ZFS.
    ssd      = 1
    iothread = 1      # Un thread de I/O por disco → mejor throughput.
  }

  # Disco Cloud-Init (obligatorio en plantillas CI de Proxmox)
  disk {
    slot    = "ide2"
    type    = "ide"
    storage = var.storage_pool
    size    = "4M"
    cdrom   = true
  }

  # ---------------------------------------------------------------------------
  # Red — VLAN tag aplicado en el puerto virtual
  # ---------------------------------------------------------------------------
  network {
    model   = "virtio"
    bridge  = var.network_bridge
    tag     = var.network_vlan
    macaddr = ""  # Proxmox asigna MAC única automáticamente.
  }

  # ---------------------------------------------------------------------------
  # Cloud-Init
  # ---------------------------------------------------------------------------
  os_type    = "cloud-init"
  ipconfig0  = "ip=${var.ip_address}/${var.cidr_prefix},gw=${var.gateway}"
  nameserver = var.dns_servers
  ciuser     = var.ci_user
  sshkeys    = var.ci_ssh_key

  # ---------------------------------------------------------------------------
  # Tags para organización en la UI de Proxmox
  # ---------------------------------------------------------------------------
  tags = join(";", concat(["terraform"], var.tags))

  # ---------------------------------------------------------------------------
  # Ciclo de vida: evita recrear la VM por cambios menores no funcionales
  # ---------------------------------------------------------------------------
  lifecycle {
    ignore_changes = [
      desc,
      tags,
      network,   # Evita drift por cambio de MAC autogenerada.
    ]
  }
}
