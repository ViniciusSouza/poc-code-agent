variable "tags" {
  description = "Tags to apply to the resource group"
  type        = map(string)
  default     = {}
}

resource "azurerm_resource_group" "main" {
  name     = "drift-detector-rg"
  location = "eastus"
  
  tags = var.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "resource_group_id" {
  value = azurerm_resource_group.main.id
}
