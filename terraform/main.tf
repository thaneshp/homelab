module "kubernetes_master_node" {
  source = "./modules/vm"

  vm_name           = "master-node"
  proxmox_node      = "proxmox"
  vm_template_name  = "ubuntu-25.10"
  memory            = 3072 # 3GB RAM for the master node
  cpu_cores         = 2
  disk_size         = "20G"
  enable_qemu_agent = 1
}

module "kubernetes_worker_nodes" {
  source = "./modules/vm"

  for_each = toset(["worker-node-1", "worker-node-2"])

  vm_name           = each.value
  proxmox_node      = "proxmox"
  vm_template_name  = "ubuntu-25.10"
  memory            = 2048
  cpu_cores         = 2
  disk_size         = "20G"
  enable_qemu_agent = 1
}
