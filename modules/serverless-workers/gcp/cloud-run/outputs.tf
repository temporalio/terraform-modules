output "invoker_email" {
  description = "Email of the invoker service account (the terminal identity of the Temporal serverless workers impersonation chain)"
  value       = google_service_account.invoker.email
}

output "invoker_id" {
  description = "Fully-qualified resource id of the invoker service account"
  value       = google_service_account.invoker.name
}
