# Terraform/Ansible test
This project performs two tasks:
1. Create infrastructure on the GCP.
2. Configure an Nginx server running a Flask app.

## Installation on macOS
```bash
$ brew install ansible terraform
```

## Preparation
- Store a service account key from the GCP Console in the root of this project, named `service_account.json`.
- Make sure to have run `gcloud auth application-default login`, which creates `~/.ssh/google_compute_engine`.
- In [`./ansible/inventory/hosts_gcp.yml.tpl`](./ansible/inventory/hosts_gcp.yml.tpl), edit the project(s) used in GCP.

## Usage
```bash
$ terraform init  # Download required plugins.
$ terraform apply  # Create cloud infrastructure.
$ ansible-playbook -i ansible/playbook.yml --key-file ~/.ssh/google_compute_engine  # Provision server.
$ terraform destroy  # Destroy generated infrastructure.
```
