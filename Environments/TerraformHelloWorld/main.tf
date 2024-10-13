provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "ade-generated-resources"
  location = "West Europe"
}