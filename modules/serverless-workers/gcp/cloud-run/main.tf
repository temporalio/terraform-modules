# Invoker identity: the terminal SA of the Temporal serverless workers' impersonation
# chain that reads and scales the Cloud Run worker pool. It never runs the pool,
# so runtime power stays off this identity.
resource "google_service_account" "invoker" {
  project      = var.project_id
  account_id   = var.invoker_account_id
  display_name = var.invoker_display_name
}

# Cloud Run permissions needed to read (get) and scale (update) the worker pool.
resource "google_project_iam_member" "deploy_roles" {
  for_each = var.deploy_roles
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.invoker.email}"
}

# Inbound trust: the prior hops in the chain mint tokens to become the invoker.
# This is the last hop of the impersonation chain.
resource "google_service_account_iam_member" "impersonators" {
  for_each           = var.impersonator_service_account_emails
  service_account_id = google_service_account.invoker.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.value}"
}

# Used to resolve the project's default Compute Engine service account, which
# Cloud Run worker pools run as when no runner is specified.
data "google_project" "this" {
  project_id = var.project_id
}

# Runtime identity the worker pool runs as. Caller-provided when set; otherwise
# the project default Compute Engine service account that Cloud Run uses by
# default. This module never creates the runner (see actAs binding below).
locals {
  runner_service_account_email = coalesce(
    var.runner_service_account_email,
    "${data.google_project.this.number}-compute@developer.gserviceaccount.com",
  )
}

# The invoker needs actAs on the runner to attach it as the worker pool's
# service identity on CreateWorkerPool / UpdateWorkerPool.
resource "google_service_account_iam_member" "invoker_act_as_runner" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${local.runner_service_account_email}"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.invoker.email}"
}
