locals {
  sa_email    = tolist(var.temporal_service_account_emails)[0]
  is_export   = length(regexall("export-.*", local.sa_email)) > 0
  is_auditlog = length(regexall("auditlog-.*", local.sa_email)) > 0
}

resource "google_service_account" "test-customer-sa" {
  account_id   = var.service_account_id
  display_name = "Service account allow Temporal write to sink"
}

resource "google_storage_bucket_iam_member" "service_account_storage_access" {
  role   = "roles/storage.objectCreator"
  bucket = var.sink_name
  member = "serviceAccount:${google_service_account.test-customer-sa.email}"
  count  = local.is_export ? 1 : 0
}

resource "google_pubsub_topic_iam_member" "service_account_pubsub_access" {
  role   = "roles/pubsub.publisher"
  topic  = var.sink_name
  member = "serviceAccount:${google_service_account.test-customer-sa.email}"
  count  = local.is_auditlog ? 1 : 0
}

resource "google_service_account_iam_member" "service_account_token_creator_role" {
  for_each           = var.temporal_service_account_emails
  service_account_id = google_service_account.test-customer-sa.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.key}"
}

