# Terraform Azure Service Principal Module For Export

This submodule facilitates the configuration of an Azure service principal and role assignment, an essential step in the overall setup for Export. The module provides support for the following functionalities:

- Referencing an existing multi-tenant app registration service principal.
- Creating a custom role definition with minimal Storage blob write permissions.
- Assigning the custom role to the service principal on the target storage account.

## Usage

Basic usage of this submodule is as follows:

```hcl
module "export-sa-azure" {
    source  = "terraform-modules/modules/export-sa-azure"
    version = "~> 4.0"

    multitenant_app_client_id = "<CLIENT ID of the multi-tenant app registration>"
    role_assignment_scope     = "<SCOPE e.g. /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg>"
    storage_account_id        = "<STORAGE ACCOUNT RESOURCE ID>"
}
```
