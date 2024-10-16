# Configure desired versions of terraform, azurerm provider
terraform {
  required_version = ">= 1.1.7, < 2.0.0"
  required_providers {
    azurerm = {
      version = "~>3.97.1"
      source  = "hashicorp/azurerm"
    }

  }
      backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate31138"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
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

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  number  = true
}
resource "azurerm_storage_account" "example" {
  name                     = "stoyaya${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}