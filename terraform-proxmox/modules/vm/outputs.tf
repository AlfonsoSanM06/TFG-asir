# =============================================================================
# MODULE vm — outputs.tf
# Valores exportados al root module tras el apply.
# =============================================================================

output "vm_id" {
  description = "VMID de la VM creada en Proxmox."
  value       = proxmox_vm_qemu.this.vmid
}

output "vm_name" {
  description = "Nombre de la VM creada en Proxmox."
  value       = proxmox_vm_qemu.this.name
}

output "ip" {
  description = "IP estática asignada a la VM."
  value       = var.ip_address
}
