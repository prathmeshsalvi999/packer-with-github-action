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
  default = "us-central1"
}

source "googlecompute" "debian" {
  project_id      = var.project_id
  zone            = "${var.region}-a"
  source_image    = "debian-11-bullseye-v20230814"
  image_name      = "packer-image-{{timestamp}}"
  machine_type    = "e2-medium"
  # 👇 REQUIRED: Username Packer will use to SSH into the instance
  ssh_username    = "packer"
}

build {
  sources = ["source.googlecompute.debian"]
}
