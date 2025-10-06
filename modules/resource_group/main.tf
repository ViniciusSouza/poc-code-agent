# Resource Group Module
# This module creates an Azure Resource Group with proper tags

resource "azurerm_resource_group" "main" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
