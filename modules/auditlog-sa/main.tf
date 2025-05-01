resource "google_service_account" "auditlog_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = "Service account allow Temporal write to sink"
}

resource "google_pubsub_topic_iam_member" "service_account_pubsub_access" {
  role   = "roles/pubsub.publisher"
  topic  = var.destination_name
  member = "serviceAccount:${google_service_account.auditlog_sa.email}"
}

resource "google_service_account_iam_member" "service_account_token_creator_role" {
  for_each           = var.temporal_service_account_emails
  service_account_id = google_service_account.auditlog_sa.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.key}"
}


