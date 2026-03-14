variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of memory (in MB) for the VM"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Size of the disk (in GB) for the VM"
  type        = string
  default     = "8G"
}

variable "vm_template_name" {
  description = "Name of the VM template to clone"
  type        = string
}

variable "enable_qemu_agent" {
  description = "Whether to enable the QEMU agent"
  default     = 1 # 1 for true, 0 for false
}
