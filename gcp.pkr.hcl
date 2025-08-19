packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "project_id" {
  type    = string
  default = "prathmesh-sandbox-468318"
}

variable "image_name" {
  type    = string
  default = "packer-image-{{timestamp}}"
}

source "googlecompute" "ubuntu" {
  image_name          = "packer-ubuntu-gcp-{{timestamp}}"
  project_id      = var.project_id
  source_image_family = "ubuntu-2204-lts"
  #source_image_project_id = "ubuntu-os-cloud"
  zone            = "asia-east1-a"
  machine_type    = "e2-medium"
  image_name      = var.image_name
  disk_size       = 10
}

build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
