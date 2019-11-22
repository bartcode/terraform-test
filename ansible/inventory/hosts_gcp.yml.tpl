plugin: gcp_compute
auth_kind: serviceaccount
service_account_file: service_account.json
projects:
  - playground-bart
# Create groups from GCE tags.
keyed_groups:
  - prefix: ""
    separator: ""
    key: tags['items']
