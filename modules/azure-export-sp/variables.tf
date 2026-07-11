variable "multitenant_app_client_id" {
  description = "Client ID / Application ID of the multi-tenant app registration"
  type        = string
}

variable "role_assignment_scope" {
  description = "Scope where the custom role definition lives (resource group or broader). e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
  type        = string
}

variable "storage_account_id" {
  description = "Full resource ID of the storage account to assign the role on. e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorage"
  type        = string
}
