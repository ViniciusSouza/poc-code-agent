terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate a random suffix for resource naming to ensure uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
  lower   = true
}

# Resource Group
module "resource_group" {
  source = "./modules/resource-group"
  
  name     = "rg-drift-test-${random_string.suffix.result}"
  location = var.location
  
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}

# Storage Account
module "storage_account" {
  source = "./modules/storage-account"
  
  name                     = "stdrift${random_string.suffix.result}"
  resource_group_name      = module.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  container_name           = "test-container"
  
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}
