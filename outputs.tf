output "resource_group_name" {
  description = "The name of the created resource group"
  value       = module.resource_group.name
}

output "storage_account_name" {
  description = "The name of the created storage account"
  value       = module.storage_account.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = module.storage_account.id
}
