output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_container_name" {
  description = "The name of the storage container"
  value       = module.storage_account.container_name
}

output "random_suffix" {
  description = "The random suffix used for resource naming"
  value       = random_string.suffix.result
}
