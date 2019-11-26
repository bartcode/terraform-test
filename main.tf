variable "domains" {
  default = [
    "test.bartstravel.guide"
  ]
}
variable "size" {
  default = 2
}
variable "project" {
  default = "playground-bart"
}
variable "region" {
  default = "europe-west4"
}
variable "zone" {
  default = "europe-west4-b"
}

// Configure the Google Cloud Platform provider
provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

provider "google-beta" {
  project = var.project
  region = var.region
  zone = var.zone
}

// Creating random ID
resource "random_id" "instance" {
  count = var.size
  byte_length = 8
}

// A single Google Compute Engine instance
resource "google_compute_instance" "webservers" {
  name = "flask-vm-${random_id.instance[count.index].hex}"
  machine_type = "f1-micro"
  count = var.size

  tags = [
    "web"
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_instance_group" "webservers" {
  name = "webservers"
  description = "Instance group"

  instances = google_compute_instance.webservers.*.self_link

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name = "web-cert"

  managed {
    domains = var.domains
  }
}

module "gce-lb-http" {
  source = "GoogleCloudPlatform/lb-http/google"
  name = "web-lb"
  project = "playground-bart"
  target_tags = [
    "web"
  ]
  backends = {
    "0" = [
      {
        group = google_compute_instance_group.webservers.self_link
        description = "Webservers"
        max_utilization = 0.8
        balancing_mode = null
        capacity_scaler = null
        max_connections = null
        max_connections_per_instance = null
        max_rate = null
        max_rate_per_instance = null
      }
    ]
  }
  backend_params = [
    # health check path, port name, port number, timeout seconds.
    "/,http,80,10"
  ]
  ssl = true
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.self_link
  ]
  use_ssl_certificates = true
}

output "hostnames" {
  value = google_compute_instance.webservers.*.name
}

output "certificate-ip" {
  value = module.gce-lb-http.external_ip
}
