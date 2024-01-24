variable "service_account_id" {
  description = "The id of service account that allow Temporal write to sink."
  type        = string
}

variable "gcp_project_id" {
  description = "The id of google project."
  type        = string
}

variable "temporal_service_account_emails" {
  description = "The Temporal service account to trust"
  type        = set(string)
}

variable "sink_name" {
  description = "The name of pub/sub topic or gcs bucket"
  type        = string
}