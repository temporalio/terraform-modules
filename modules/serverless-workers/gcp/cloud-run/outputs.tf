output "invoker_email" {
  description = "Email of the invoker service account (the terminal identity of the Temporal serverless workers impersonation chain)"
  value       = google_service_account.invoker.email
}

output "invoker_id" {
  description = "Fully-qualified resource id of the invoker service account"
  value       = google_service_account.invoker.name
}

output "runner_service_account_email" {
  description = "Email of the service account the worker pool runs as (the value supplied in runner_service_account_email). Set this as the worker pool's service_account (spec.template.serviceAccount)"
  value       = var.runner_service_account_email
}
