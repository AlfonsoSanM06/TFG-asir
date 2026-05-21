# =============================================================================
# VERSIONS — Pin explícito de Terraform y providers para reproducibilidad total.
# La configuración del backend se gestiona en backend.tf.
# =============================================================================

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure

  # Paralelismo conservador para no saturar la API de Proxmox.
  pm_parallel = 2
  pm_log_enable = false
}
