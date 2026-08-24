variable "project_id" {
  description = "The GCP project that hosts the Cloud Run worker pool and the invoker service account"
  type        = string
}

variable "invoker_account_id" {
  description = "Account id of the invoker service account that reads and scales the worker pool (terminal identity of the Temporal serverless workers impersonation chain)"
  type        = string
}

variable "invoker_display_name" {
  description = "Display name for the invoker service account"
  type        = string
  default     = "Temporal Serverless Worker Pool Invoker"
}

variable "impersonator_service_account_emails" {
  description = "Emails of the upstream service accounts allowed to impersonate the invoker (the prior hops in the Temporal serverless workers impersonation chain). Each is granted token-creator on the invoker"
  type        = set(string)
}

variable "deploy_roles" {
  description = "Project-level Cloud Run roles granted to the invoker. Any role used must include at least run.workerPools.get and run.workerPools.update. Defaults to roles/run.developer, which includes both"
  type        = set(string)
  default     = ["roles/run.developer"]
}

variable "runner_service_account_email" {
  description = "Email of the dedicated service account the Cloud Run worker pool runs as. Required: you create this service account and grant it the least-privilege roles the pool needs (see README); the invoker is granted actAs on it so it can attach it as the pool's service identity. This module does not create the runner and does not fall back to the project default Compute Engine service account"
  type        = string

  validation {
    condition     = can(regex("@[^@]+\\.gserviceaccount\\.com$", var.runner_service_account_email))
    error_message = "runner_service_account_email must be a GCP service account email (for example name@PROJECT.iam.gserviceaccount.com). Supply a dedicated runner service account; this module does not create one or fall back to the default Compute Engine service account."
  }
}
