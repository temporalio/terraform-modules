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
