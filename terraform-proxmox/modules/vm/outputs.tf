# =============================================================================
# MODULE vm — outputs.tf
# Valores exportados al root module tras el apply.
# Provider: bpg/proxmox → recurso proxmox_virtual_environment_vm
# =============================================================================

output "vm_id" {
  description = "VMID de la VM creada en Proxmox."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  description = "Nombre de la VM creada en Proxmox."
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip" {
  description = "IP estática asignada a la VM."
  value       = var.ip_address
}
