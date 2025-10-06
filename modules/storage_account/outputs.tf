output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
