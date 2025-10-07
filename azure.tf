# Azure Infrastructure Configuration
# This file documents the current state of Azure resources

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

# Resource Group Module
module "resource_group" {
  source = "./modules/resource_group"

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}

# Storage Account Module
module "storage_account" {
  source = "./modules/storage_account"

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }

  min_tls_version = "TLS1_2" # Current cloud state uses TLS1_2
}
