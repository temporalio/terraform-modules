# Terraform GCP Service Account Module For Cloud Run Serverless Workers

This module facilitates the configuration of a GCP service account, an essential step in the overall setup for Serverless Workers on Cloud Run. The module provides support for the following functionalities:

- Creation of an invoker service account in the customer's GCP project.
- Establishing trust with the Temporal Cloud service accounts by granting them `roles/iam.serviceAccountTokenCreator` on the invoker, so the Temporal Cloud impersonation chain can act as it.
- Granting the invoker the Cloud Run permissions needed to read and scale the worker pool (at minimum `run.workerPools.get` and `run.workerPools.update`) through `deploy_roles` (default `roles/run.developer`, which includes both permissions).

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.7
- Google provider ~> 4.0
- GCP credentials configured for the project where the Cloud Run worker pool is deployed
- The `impersonator_service_account_emails` values provided by Temporal Cloud

## Usage

Basic usage of this module is as follows:

```hcl
module "serverless-worker-cloud-run" {
  source = "terraform-modules/modules/serverless-workers/gcp/cloud-run"

  project_id         = "my-worker-project"
  invoker_account_id = "temporal-serverless-worker"

  impersonator_service_account_emails = [
    "<provided by Temporal Cloud>",
  ]

  # Optional: override the default Cloud Run roles
  # deploy_roles = ["roles/run.developer"]
}
```

Once applied, provide the `invoker_email` output value to Temporal Cloud to complete the setup.

> **Note:** Temporal Cloud only reads and scales the worker pool as the invoker. If you replace the default `deploy_roles` with a custom (least-privilege) role, that role must grant at least the following permissions:
>
> - `run.workerPools.get`
> - `run.workerPools.update`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project_id` | GCP project that hosts the Cloud Run worker pool and the invoker service account. | `string` | — | yes |
| `invoker_account_id` | Account id of the invoker service account that creates, updates, and scales the worker pool. | `string` | — | yes |
| `impersonator_service_account_emails` | Temporal Cloud service account emails permitted to impersonate the invoker. Provided by Temporal Cloud. | `set(string)` | — | yes |
| `invoker_display_name` | Display name for the invoker service account. | `string` | `Temporal Serverless Worker Pool Invoker` | no |
| `deploy_roles` | Project-level Cloud Run roles granted to the invoker. Any role used must include at least `run.workerPools.get` and `run.workerPools.update`. | `set(string)` | `["roles/run.developer"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `invoker_email` | Email of the created invoker service account. Provide this to Temporal Cloud. |
| `invoker_id` | Fully-qualified resource id of the created invoker service account. |
