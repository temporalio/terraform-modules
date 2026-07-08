terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.75"
    }
  }
}
