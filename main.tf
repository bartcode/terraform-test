// Configure the Google Cloud Platform provider
provider "google" {
  project = "playground-bart"
  region = "europe-west4"
  zone = "europe-west4-b"
}

// Creating random ID
resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Google Compute Engine instance
resource "google_compute_instance" "default" {
  name = "flask-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"

  tags = ["web"]

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

output "hostnames" {
  value = google_compute_instance.default.*.name
}

resource "local_file" "hosts" {
  content = templatefile("ansible/inventory/hosts_gcp.yml.tpl", {
    hostnames = google_compute_instance.default.*.name
  })
  filename = "hosts_gcp.yml"
}

resource "google_compute_firewall" "default" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["80"]
 }
}
