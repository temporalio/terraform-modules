# Terraform GCP Sink Service Account Module

This submodule facilitates the configuration of a GCP sink service account, an essential step in the overall setup of a GCP sink. The module provides support for the following functionalities:

- Creation of a service account within the customer's GCP project.
- Granting write permissions to either GCP Storage or Pub/Sub.
- Establishing trust with the temporal internal service account.
- Provisioning encryption/decryption privileges when Customer-Managed Encryption Keys (CMEK) are enabled on the storage.

## Usage

Basic usage of this submodule is as follows:

```hcl
module "gcp-sink-sa" {
    source  = "terraform-modules/modules/gcp-sink-sa"
    version = "~> 4.0"

    service_account_id              = "<SA ID >"
    gcp_project_id                  = "<PROJECT ID>"
    destination_name                = "<GCS BUCKET NAME OR PUBSUB TOPIC NAME>"
    temporal_service_account_emails = "<[...,...]>"
}
```