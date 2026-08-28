# Terraform GCP Service Account Module For Cloud Run Serverless Workers

This module facilitates the configuration of a GCP service account, an essential step in the overall setup for Serverless Workers on Cloud Run. The module provides support for the following functionalities:

- Creation of an invoker service account in the customer's GCP project.
- Establishing trust with the Temporal Cloud service accounts by granting them `roles/iam.serviceAccountTokenCreator` on the invoker, so the Temporal Cloud impersonation chain can act as it.
- Granting the invoker the Cloud Run permissions needed to read and scale the worker pool (at minimum `run.workerPools.get` and `run.workerPools.update`) through `deploy_roles` (default `roles/run.developer`, which includes both permissions).
- Granting the invoker `roles/iam.serviceAccountUser` (actAs) on the runner service account the worker pool runs as, so it can attach that identity to the pool. The runner is **required** (`runner_service_account_email`): you create it and grant it the least-privilege roles the pool needs. This module does not create the runner, grant it workload roles, or fall back to the project's default Compute Engine service account.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.7
- Google provider ~> 4.0
- GCP credentials configured for the project where the Cloud Run worker pool is deployed
- The `impersonator_service_account_emails` values provided by Temporal Cloud
- A dedicated **runner** service account for the worker pool to run as, with the roles listed under [Runner service account](#runner-service-account)

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

  # Required: the dedicated service account the worker pool runs as. You create
  # it and grant it the least-privilege roles below; the module grants the
  # invoker actAs on it. There is no default — an unset or non-service-account
  # value fails validation.
  runner_service_account_email = "temporal-worker-pool-runner@my-worker-project.iam.gserviceaccount.com"

  # Optional: override the default Cloud Run roles
  # deploy_roles = ["roles/run.developer"]
}
```

Once applied, provide the `invoker_email` output value to Temporal Cloud to complete the setup, and set `runner_service_account_email` as the worker pool's service identity (`spec.template.serviceAccount`).

## Runner service account

You create the runner service account (this module does not) and grant it only the roles a Temporal worker with the Google-Built OpenTelemetry Collector sidecar needs:

- `roles/monitoring.metricWriter` — metrics to Google Managed Service for Prometheus.
- `roles/telemetry.tracesWriter` — traces via the Telemetry API.
- `roles/secretmanager.secretAccessor` **on each secret the pool injects** (the collector config, and a Temporal API key if used). Cloud Run resolves a pool's secret env vars and volume mounts as the runner, so it must be able to read every secret the pool references.

Cloud Run captures container stdout to Cloud Logging without a runtime role, and the metadata server needs none, so `roles/logging.logWriter` and `roles/serviceusage.serviceUsageConsumer` are **not** required.

Example:

```sh
gcloud iam service-accounts create temporal-worker-pool-runner --project "$PROJECT_ID"
RUNNER="temporal-worker-pool-runner@${PROJECT_ID}.iam.gserviceaccount.com"

for role in roles/monitoring.metricWriter roles/telemetry.tracesWriter; do
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member "serviceAccount:${RUNNER}" --role "$role"
done

# Repeat for every secret the pool injects (collector config, API key, ...).
gcloud secrets add-iam-policy-binding "$SECRET_ID" \
  --member "serviceAccount:${RUNNER}" --role roles/secretmanager.secretAccessor
```

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
| `runner_service_account_email` | Email of the dedicated service account the worker pool runs as. You create it and grant it the roles above; the invoker is granted actAs on it. No default and no fallback — an empty or non-service-account value fails validation. | `string` | — | yes |
| `invoker_display_name` | Display name for the invoker service account. | `string` | `Temporal Serverless Worker Pool Invoker` | no |
| `deploy_roles` | Project-level Cloud Run roles granted to the invoker. Any role used must include at least `run.workerPools.get` and `run.workerPools.update`. | `set(string)` | `["roles/run.developer"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `invoker_email` | Email of the created invoker service account. Provide this to Temporal Cloud. |
| `invoker_id` | Fully-qualified resource id of the created invoker service account. |
| `runner_service_account_email` | Email of the service account the worker pool runs as. Set as the pool's `spec.template.serviceAccount`. |
