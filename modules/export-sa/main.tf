resource "google_service_account" "export_sa" {
  project      = var.gcp_project_id
  account_id   = var.service_account_id
  display_name = "Service account allow Temporal write to Export sink"
}

resource "google_storage_bucket_iam_member" "service_account_storage_access" {
  role   = "roles/storage.objectCreator"
  bucket = var.destination_name
  member = "serviceAccount:${google_service_account.export_sa.email}"
}

resource "google_storage_bucket_iam_member" "service_account_bucket_access" {
  role   = "roles/storage.buckets.get"
  bucket = var.destination_name
  member = "serviceAccount:${google_service_account.export_sa.email}"
}

resource "google_service_account_iam_member" "service_account_token_creator_role" {
  for_each           = var.temporal_service_account_emails
  service_account_id = google_service_account.export_sa.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.key}"
}


