# Terraform/Ansible test
This project performs a few tasks:
1. Create infrastructure on the GCP.
2. Configure an Nginx server running a Flask app.
3. Set up HTTP(S) load balancer.

## Installation on macOS
```bash
$ brew install ansible terraform
```

## Preparation
- Store a service account key from the GCP Console in the root of this project, named `service_account.json`.
- Make sure to have run `gcloud auth application-default login`, which creates `~/.ssh/google_compute_engine`.
- In [`./hosts_gcp.yml.tpl`](hosts_gcp.yml), edit the project(s) used in GCP.
- Update the variable domain name(s) in [`./main.tf`](./main.tf), which are used for the SSL certificates.

## Usage
```bash
$ terraform init  # Download required plugins.
$ terraform apply  # Create cloud infrastructure.
$ ansible-playbook -i ansible/playbook.yml --key-file ~/.ssh/google_compute_engine  # Provision server.
$ terraform destroy  # Destroy generated infrastructure.
```

The output variable `certificate-ip` should be used when creating a DNS record.
