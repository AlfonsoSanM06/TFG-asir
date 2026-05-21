# =============================================================================
# OUTPUTS — arq3d-infrastructure
# Expone los valores clave tras el apply para que Ansible los consuma.
# Úsalos con: terraform output -json > ../ansible/inventory_vars.json
# =============================================================================

output "k8s_master_01" {
  description = "VMID e IP del nodo master de Kubernetes."
  value = {
    vm_id = module.k8s_master_01.vm_id
    name  = module.k8s_master_01.vm_name
    ip    = module.k8s_master_01.ip
  }
}

output "k8s_worker_01" {
  description = "VMID e IP del nodo worker 01."
  value = {
    vm_id = module.k8s_worker_01.vm_id
    name  = module.k8s_worker_01.vm_name
    ip    = module.k8s_worker_01.ip
  }
}

output "k8s_worker_02" {
  description = "VMID e IP del nodo worker 02."
  value = {
    vm_id = module.k8s_worker_02.vm_id
    name  = module.k8s_worker_02.vm_name
    ip    = module.k8s_worker_02.ip
  }
}

output "ldap_server" {
  description = "VMID e IP del servidor LDAP."
  value = {
    vm_id = module.ldap_server.vm_id
    name  = module.ldap_server.vm_name
    ip    = module.ldap_server.ip
  }
}

# Bloque conveniente para pegar directamente en el inventory.yml de Ansible.
output "ansible_inventory_hint" {
  description = "IPs de todos los nodos para construir el inventario de Ansible."
  value = {
    k8s_masters = [module.k8s_master_01.ip]
    k8s_workers = [
      module.k8s_worker_01.ip,
      module.k8s_worker_02.ip,
    ]
    ldap = [module.ldap_server.ip]
  }
}
