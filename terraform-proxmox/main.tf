# =============================================================================
# MAIN — arq3d-infrastructure
# Orquesta la creación de las 4 VMs del proyecto usando el módulo local `vm`.
# =============================================================================

# -----------------------------------------------------------------------------
# Locals: valores derivados que no necesitan ser variables públicas.
# -----------------------------------------------------------------------------
locals {
  # Metadata común inyectada en todos los nodos.
  common_tags = ["arq3d", "tfg-asir"]

  # Parámetros de red compartidos por los 4 nodos.
  network = {
    bridge      = var.network_bridge
    vlan        = var.network_vlan_tag
    gateway     = var.network_gateway
    dns_servers = var.network_dns_servers
    cidr_prefix = var.network_cidr_prefix
  }

  # Cloud-Init común.
  ci = {
    user    = var.ci_default_user
    ssh_key = var.ci_ssh_public_key
  }
}

# -----------------------------------------------------------------------------
# k8s-master-01 — Nodo master del clúster Kubernetes
# -----------------------------------------------------------------------------
module "k8s_master_01" {
  source = "./modules/vm"

  vm_id          = var.master_vm_id
  vm_name        = "k8s-master-01"
  vm_description = "K8s Control Plane — ARQ3D | Managed by Terraform"
  proxmox_node   = var.proxmox_node
  template_name  = var.vm_template_name
  storage_pool   = var.vm_storage_pool

  cpu_cores  = var.master_cpu
  ram_mb     = var.master_ram_mb
  disk_size_gb = var.master_disk_gb

  network_bridge = local.network.bridge
  network_vlan   = local.network.vlan
  ip_address     = var.master_ip
  cidr_prefix    = local.network.cidr_prefix
  gateway        = local.network.gateway
  dns_servers    = local.network.dns_servers

  ci_user    = local.ci.user
  ci_ssh_key = local.ci.ssh_key

  tags = concat(local.common_tags, ["k8s", "master"])
}

# -----------------------------------------------------------------------------
# k8s-worker-01 — Nodo worker (web corporativa + ArgoCD)
# -----------------------------------------------------------------------------
module "k8s_worker_01" {
  source = "./modules/vm"

  vm_id          = var.worker01_vm_id
  vm_name        = "k8s-worker-01"
  vm_description = "K8s Worker 01 — Web + ArgoCD | Managed by Terraform"
  proxmox_node   = var.proxmox_node
  template_name  = var.vm_template_name
  storage_pool   = var.vm_storage_pool

  cpu_cores    = var.worker01_cpu
  ram_mb       = var.worker01_ram_mb
  disk_size_gb = var.worker01_disk_gb

  network_bridge = local.network.bridge
  network_vlan   = local.network.vlan
  ip_address     = var.worker01_ip
  cidr_prefix    = local.network.cidr_prefix
  gateway        = local.network.gateway
  dns_servers    = local.network.dns_servers

  ci_user    = local.ci.user
  ci_ssh_key = local.ci.ssh_key

  tags = concat(local.common_tags, ["k8s", "worker"])

  # Los workers deben crearse después del master para seguir el orden lógico.
  depends_on = [module.k8s_master_01]
}

# -----------------------------------------------------------------------------
# k8s-worker-02 — Nodo worker (Nextcloud HA)
# -----------------------------------------------------------------------------
module "k8s_worker_02" {
  source = "./modules/vm"

  vm_id          = var.worker02_vm_id
  vm_name        = "k8s-worker-02"
  vm_description = "K8s Worker 02 — Nextcloud HA | Managed by Terraform"
  proxmox_node   = var.proxmox_node
  template_name  = var.vm_template_name
  storage_pool   = var.vm_storage_pool

  cpu_cores    = var.worker02_cpu
  ram_mb       = var.worker02_ram_mb
  disk_size_gb = var.worker02_disk_gb

  network_bridge = local.network.bridge
  network_vlan   = local.network.vlan
  ip_address     = var.worker02_ip
  cidr_prefix    = local.network.cidr_prefix
  gateway        = local.network.gateway
  dns_servers    = local.network.dns_servers

  ci_user    = local.ci.user
  ci_ssh_key = local.ci.ssh_key

  tags = concat(local.common_tags, ["k8s", "worker"])

  depends_on = [module.k8s_master_01]
}

# -----------------------------------------------------------------------------
# ldap-server — Servidor de identidad independiente del clúster
# -----------------------------------------------------------------------------
module "ldap_server" {
  source = "./modules/vm"

  vm_id          = var.ldap_vm_id
  vm_name        = "ldap-server"
  vm_description = "OpenLDAP Identity Server — ARQ3D | Managed by Terraform"
  proxmox_node   = var.proxmox_node
  template_name  = var.vm_template_name
  storage_pool   = var.vm_storage_pool

  cpu_cores    = var.ldap_cpu
  ram_mb       = var.ldap_ram_mb
  disk_size_gb = var.ldap_disk_gb

  network_bridge = local.network.bridge
  network_vlan   = local.network.vlan
  ip_address     = var.ldap_ip
  cidr_prefix    = local.network.cidr_prefix
  gateway        = local.network.gateway
  dns_servers    = local.network.dns_servers

  ci_user    = local.ci.user
  ci_ssh_key = local.ci.ssh_key

  # El LDAP puede levantarse en paralelo al clúster K8s.
  tags = concat(local.common_tags, ["ldap", "identity"])
}
