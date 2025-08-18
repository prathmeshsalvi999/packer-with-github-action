packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0"
    }
  }
}

variable "project_id" {
  type    = string
  default = "prathmesh-sandbox-468318"
}

variable "region" {
  type    = string
  default = "asia-east1-a"
}

variable "gcp_credentials_path" {
  type      = string
  default = "GOOGLE_APPLICATION_CREDENTIALS"
  sensitive = true
}

#source "googlecompute" "debian" {
# project_id      = var.project_id
#  zone            = "${var.region}-a"
#  source_image    = "debian-11-bullseye-v20230814"
#  image_name      = "packer-image-{{timestamp}}"
#  machine_type    = "n1-standard-2"
  # 👇 REQUIRED: Username Packer will use to SSH into the instance
 # ssh_username    = "packer"
#}

#build {
  #sources = ["source.googlecompute.debian"]
#}

source "googlecompute" "windows-2025" {
  image_name          = "packer-win2025-gcp-{{timestamp}}"
  image_description   = "windows-2025 server-{{timestamp}}"
  project_id          =  "var.project_id"
  source_image        = "windows-server-2025-dc-v20250710"
  source_image_family = "windows-2019"
  zone                = "${var.region}-a"
  disk_size           = 50
  machine_type        = "n1-standard-2"
  communicator        = "winrm"
  winrm_username      = "packer_user"
  winrm_insecure      = true
  winrm_use_ssl       = true
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer_user & net localgroup administrators packer_user /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
}
build {
  sources = ["sources.googlecompute.windows-2025"]
   provisioner "powershell" {
     environment_vars = [
      "GOOGLE_APPLICATION_CREDENTIALS={{ user `gcp_credentials_path` }}"
  ]
     inline = [
      "Write-Host 'Credentials path: $env:GOOGLE_APPLICATION_CREDENTIALS'"
  ]
}



}
