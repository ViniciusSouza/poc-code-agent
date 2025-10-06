# Main Terraform configuration for Azure infrastructure
# This file defines the infrastructure resources to prevent drift

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

# Generate a random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
  lower   = true
}

# Resource Group Module
module "resource_group" {
  source = "./modules/resource_group"

  name     = "rg-drift-test-${random_string.suffix.result}"
  location = "eastus"
  
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

  name                = "stdrift${random_string.suffix.result}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  
  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "drift-detector-test"
    Purpose     = "testing-drift-detection"
  }
}
