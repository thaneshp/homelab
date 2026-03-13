terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.4.72:8006/api2/json"
  pm_tls_insecure = true
}
