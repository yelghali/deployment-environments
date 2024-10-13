# Configure desired versions of terraform, azurerm provider
terraform {
  required_version = ">= 1.1.7, < 2.0.0"
  required_providers {
    azurerm = {
      version = "~>3.97.1"
      source  = "hashicorp/azurerm"
    }
  }
}

# Enable features for azurerm
provider "azurerm" {
  skip_provider_registration = "true"
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Access client_id, tenant_id, subscription_id and object_id configuration values
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = adegen
  location                 = westeurope
  resource_group_name      = var.environment_name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled = false
  sku_name                 = "standard"

  tags = var.tags
}