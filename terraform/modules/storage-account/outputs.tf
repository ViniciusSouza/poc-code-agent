output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "container_name" {
  description = "The name of the storage container"
  value       = azurerm_storage_container.test.name
}
