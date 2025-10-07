variable "tags" {
  description = "Tags to apply to the storage account"
  type        = map(string)
  default     = {}
}

variable "min_tls_version" {
  description = "Minimum TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
}

resource "azurerm_storage_account" "main" {
  name                     = "driftdetectorsa"
  resource_group_name      = "drift-detector-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  min_tls_version = var.min_tls_version
  
  tags = var.tags
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_id" {
  value = azurerm_storage_account.main.id
}
