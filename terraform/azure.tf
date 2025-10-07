terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = "drift-detector-test-rg"
  location = "eastus"
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}

module "storage_account" {
  source                   = "./modules/storage_account"
  name                     = "driftdetectorsa"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}
