resource "azuread_service_principal" "multitenant_app" {
  client_id    = var.multitenant_app_client_id
  use_existing = true

  app_role_assignment_required = false
}

resource "azurerm_role_definition" "storage_blob_writer_custom" {
  name        = "Custom Storage Blob Writer Role"
  scope       = var.role_assignment_scope
  description = "Allows reading storage accounts and writing blobs."

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/read",
    ]

    not_actions = []

    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    ]

    not_data_actions = []
  }

  assignable_scopes = [
    var.role_assignment_scope,
  ]
}

resource "azurerm_role_assignment" "multitenant_app_custom_role" {
  scope              = var.storage_account_id
  role_definition_id = azurerm_role_definition.storage_blob_writer_custom.role_definition_resource_id
  principal_id       = azuread_service_principal.multitenant_app.object_id

  principal_type = "ServicePrincipal"
}
