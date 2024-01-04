# Terraform template for Google Compute Instance
# Compatible with Terraform 4.25.0 and backwards compatible versions.
# For formatting and validation: https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

variable "instance_name" {
  description = "Name of the Compute Instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the Compute Instance"
  type        = string
  default     = "e2-standard-2"
}

variable "zone" {
  description = "Zone where the Compute Instance will be created"
  type        = string
  default     = "europe-west1-b"
}

variable "image" {
  description = "Image to be used for the Compute Instance"
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2310-mantic-amd64-v20231215"
}

variable "ssh_keys" {
  description = "SSH keys for accessing the Compute Instance"
  type        = list(string)
}

variable "subnetwork" {
  description = "Subnetwork for the Compute Instance"
  type        = string
  # Replace with your subnetwork, e.g., "projects/your-project-id/regions/your-region/subnetworks/default"
  default     = ""
}

variable "service_account_email" {
  description = "Service account email associated with the Compute Instance"
  type        = string
  # Replace with your service account email
  default     = ""
}

resource "google_compute_instance" "kernel-development" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    auto_delete = true
    device_name = "${var.instance_name}-template"

    initialize_params {
      image = var.image
      size  = 100
      type  = "pd-ssd"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  metadata = {
    ssh-keys = join("\n", var.ssh_keys)
  }

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = var.subnetwork
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.service_account_email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
}

