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
