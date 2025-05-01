# Terraform GCP Service Account Module For Auditlog

This submodule facilitates the configuration of a GCP sink service account, an essential step in the overall setup for Auditlog. The module provides support for the following functionalities:

- Creation of a service account within the customer's GCP project.
- Granting write permissions to Pub/Sub.
- Establishing trust with the temporal internal service account.
- Provisioning encryption/decryption privileges when Customer-Managed Encryption Keys (CMEK) are enabled on the storage.

## Usage

Basic usage of this submodule is as follows:

```hcl
module "auditlog-sa" {
    source  = "terraform-modules/modules/auditlog-sa"
    version = "~> 4.0"

    service_account_id              = "<SA ID >"
    gcp_project_id                  = "<PROJECT ID>"
    destination_name                = "<PUBSUB TOPIC NAME. e.g. mytesttopic>"
    temporal_service_account_emails = "<[...,...]>"
}
```