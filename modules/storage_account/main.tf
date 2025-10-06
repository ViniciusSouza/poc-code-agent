# Storage Account Module
# This module creates an Azure Storage Account with security best practices

resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  
  # Security: Enforce TLS 1.2 minimum version
  min_tls_version                = "TLS1_2"
  
  # Security: Disable public blob access
  allow_nested_items_to_be_public = false
  
  # Security: Require HTTPS
  enable_https_traffic_only = true
  
  # Disable shared access key (using Azure AD authentication)
  shared_access_key_enabled = false
  
  tags = var.tags
}

# Create a test container
resource "azurerm_storage_container" "test" {
  name                  = "test-container"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
