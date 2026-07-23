# Terraform GCP Service Account Module For Cloud Run Serverless Workers

This module facilitates the configuration of a GCP service account, an essential step in the overall setup for Serverless Workers on Cloud Run. The module provides support for the following functionalities:

- Creation of an invoker service account in the customer's GCP project.
- Establishing trust with the Temporal Cloud service accounts by granting them `roles/iam.serviceAccountTokenCreator` on the invoker, so the Temporal Cloud impersonation chain can act as it.
- Granting the invoker the Cloud Run permissions needed to read and scale the worker pool (at minimum `run.workerPools.get` and `run.workerPools.update`) through `deploy_roles` (default `roles/run.developer`, which includes both permissions).
- Granting the invoker `roles/iam.serviceAccountUser` (actAs) on the runner service account the worker pool runs as, so it can attach that identity to the pool. The runner is caller-provided via `runner_service_account_email`, or the project's default Compute Engine service account when unset. This module does not create the runner or grant it workload roles.

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

  # Optional: service account the worker pool runs as. Defaults to the project's
  # default Compute Engine service account when unset.
  # runner_service_account_email = "my-runner@my-worker-project.iam.gserviceaccount.com"
}
```

Once applied, provide the `invoker_email` output value to Temporal Cloud to complete the setup, and set `runner_service_account_email` (output) as the worker pool's service identity (`spec.template.serviceAccount`).

> **Note:** Temporal Cloud only reads and scales the worker pool as the invoker. If you replace the default `deploy_roles` with a custom (least-privilege) role, that role must grant at least the following permissions:
>
> - `run.workerPools.get`
> - `run.workerPools.update`

> **Warning:** Leaving `runner_service_account_email` unset grants the invoker `actAs` on the project's **default Compute Engine service account**. That account holds the `roles/editor` primary role by default, so the invoker can attach a highly-privileged identity to the worker pool — a compromised invoker or pool would inherit project-wide Editor. For least privilege, pass a dedicated runner service account scoped to only the workload roles the pool needs (e.g. `roles/secretmanager.secretAccessor`).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project_id` | GCP project that hosts the Cloud Run worker pool and the invoker service account. | `string` | — | yes |
| `invoker_account_id` | Account id of the invoker service account that creates, updates, and scales the worker pool. | `string` | — | yes |
| `impersonator_service_account_emails` | Temporal Cloud service account emails permitted to impersonate the invoker. Provided by Temporal Cloud. | `set(string)` | — | yes |
| `invoker_display_name` | Display name for the invoker service account. | `string` | `Temporal Serverless Worker Pool Invoker` | no |
| `deploy_roles` | Project-level Cloud Run roles granted to the invoker. Any role used must include at least `run.workerPools.get` and `run.workerPools.update`. | `set(string)` | `["roles/run.developer"]` | no |
| `runner_service_account_email` | Email of the service account the worker pool runs as. The invoker is granted actAs on it. Empty uses the project's default Compute Engine service account. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| `invoker_email` | Email of the created invoker service account. Provide this to Temporal Cloud. |
| `invoker_id` | Fully-qualified resource id of the created invoker service account. |
| `runner_service_account_email` | Email of the service account the worker pool runs as. Set as the pool's `spec.template.serviceAccount`. |
