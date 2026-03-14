resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.proxmox_node
  clone       = var.vm_template_name
  full_clone  = true
  agent       = var.enable_qemu_agent
  memory      = var.memory
  cpu {
    cores = var.cpu_cores
  }
  disk {
    size    = var.disk_size
    type    = "disk"
    storage = "local-lvm"
    discard = false
    slot    = "scsi0"
  }

  ipconfig0 = "dhcp"
  network {
    id        = 0
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = true
    link_down = false
  }
}