output "sink_service_account_email" {
  description = "The Google service account used by temporalio cloud"
  value       = google_service_account.gcp_sink_sa.email
}
