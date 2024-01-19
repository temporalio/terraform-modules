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

variable "enable_cmek" {
  description = "Set to true if customer-managed encryption keys (CMEK) is added to the bucket"
  type        = bool
}