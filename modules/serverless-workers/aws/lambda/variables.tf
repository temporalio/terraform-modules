variable "external_id" {
  description = "The External ID for cross-account role assumption."
  type        = string

  validation {
    condition     = length(var.external_id) >= 5 && length(var.external_id) <= 45 && can(regex("^[a-zA-Z0-9_+=,.@-]+$", var.external_id))
    error_message = "external_id must be 5-45 characters and contain only alphanumeric characters and _+=,.@- symbols."
  }
}

variable "temporal_cloud_principals" {
  description = "List of Temporal Cloud AWS IAM role ARNs permitted to assume this role. Provided by Temporal Cloud."
  type        = list(string)

  validation {
    condition     = length(var.temporal_cloud_principals) > 0
    error_message = "At least one Temporal Cloud principal ARN must be provided."
  }
}

variable "lambda_function_arns" {
  description = "List of Lambda function ARNs that Temporal Cloud is permitted to invoke."
  type        = list(string)

  validation {
    condition     = length(var.lambda_function_arns) > 0
    error_message = "At least one Lambda function ARN must be provided."
  }
}

variable "role_name" {
  description = "Name of the IAM role to create."
  type        = string
  default     = "Temporal-Cloud-Serverless-Worker"
}
