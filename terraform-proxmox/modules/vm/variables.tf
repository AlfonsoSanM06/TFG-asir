# =============================================================================
# MODULE vm — variables.tf
# Parámetros de entrada del módulo. Todos los valores vienen del root module.
# =============================================================================

# --- Identificación -----------------------------------------------------------
variable "vm_id" {
  description = "VMID único en Proxmox."
  type        = number
}

variable "vm_name" {
  description = "Nombre de la VM en Proxmox."
  type        = string
}

variable "vm_description" {
  description = "Descripción libre mostrada en la UI de Proxmox."
  type        = string
  default     = "Managed by Terraform — ARQ3D"
}

# --- Proxmox ------------------------------------------------------------------
variable "proxmox_node" {
  description = "Nombre del nodo Proxmox donde se despliega la VM."
  type        = string
}

variable "template_name" {
  description = "Nombre de la plantilla Cloud-Init a clonar."
  type        = string
}

variable "storage_pool" {
  description = "Pool de almacenamiento de Proxmox para los discos."
  type        = string
}

# --- Cómputo ------------------------------------------------------------------
variable "cpu_cores" {
  description = "Número de vCPUs asignadas a la VM."
  type        = number
}

variable "cpu_sockets" {
  description = "Número de sockets de CPU (1 para la mayoría de cargas)."
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "Modelo de CPU expuesto al guest. 'host' pasa la CPU física completa."
  type        = string
  default     = "host"
}

variable "ram_mb" {
  description = "Memoria RAM asignada en MiB."
  type        = number
}

variable "balloon_mb" {
  description = "Límite inferior del ballooning de memoria. 0 = desactivado (recomendado para K8s)."
  type        = number
  default     = 0
}

# --- Almacenamiento -----------------------------------------------------------
variable "disk_size_gb" {
  description = "Tamaño del disco del sistema operativo en GiB."
  type        = number
}

# --- Red ----------------------------------------------------------------------
variable "network_bridge" {
  description = "Bridge de red de Proxmox (ej. vmbr0)."
  type        = string
}

variable "network_vlan" {
  description = "VLAN tag de la red de la VM."
  type        = number
}

variable "ip_address" {
  description = "IP estática de la VM (sin prefijo CIDR)."
  type        = string
}

variable "cidr_prefix" {
  description = "Longitud del prefijo CIDR de la subred (ej. 24 → /24)."
  type        = number
}

variable "gateway" {
  description = "Puerta de enlace predeterminada de la VM."
  type        = string
}

variable "dns_servers" {
  description = "Servidores DNS separados por espacio (formato Cloud-Init)."
  type        = string
}

# --- Cloud-Init ---------------------------------------------------------------
variable "ci_user" {
  description = "Nombre del usuario no-root creado por Cloud-Init."
  type        = string
}

variable "ci_ssh_key" {
  description = "Clave pública SSH inyectada en authorized_keys del usuario Cloud-Init."
  type        = string
  sensitive   = true
}

# --- Metadatos ----------------------------------------------------------------
variable "tags" {
  description = "Lista de etiquetas para organizar la VM en la UI de Proxmox."
  type        = list(string)
  default     = []
}
