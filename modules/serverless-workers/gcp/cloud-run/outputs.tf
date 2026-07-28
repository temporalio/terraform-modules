output "invoker_email" {
  description = "Email of the invoker service account (the terminal identity of the Temporal serverless workers impersonation chain)"
  value       = google_service_account.invoker.email
}

output "invoker_id" {
  description = "Fully-qualified resource id of the invoker service account"
  value       = google_service_account.invoker.name
}

output "runner_service_account_email" {
  description = "Email of the service account the worker pool runs as (the caller-provided one, or the project default Compute Engine SA when unset). Set this as the worker pool's service_account (spec.template.serviceAccount)"
  value       = local.runner_service_account_email
}
