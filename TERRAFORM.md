# Azure Infrastructure - Terraform Configuration

This directory contains Terraform configuration for Azure infrastructure that documents the current state of cloud resources.

## Structure

- `azure.tf` - Main configuration file that defines the Azure resources
- `modules/resource_group/` - Module for Azure Resource Group
- `modules/storage_account/` - Module for Azure Storage Account

## Current State

The configuration reflects the actual state of deployed Azure resources as of 2025-10-07:

### Resource Group
- Name: `drift-detector-rg`
- Location: `eastus`
- Tags:
  - Environment: `test`
  - ManagedBy: `terraform`
  - Project: `drift-detector-test`
  - Purpose: `testing-drift-detection`

### Storage Account
- Name: `driftdetectorsa`
- Resource Group: `drift-detector-rg`
- Location: `eastus`
- Account Tier: `Standard`
- Replication Type: `LRS`
- Minimum TLS Version: `TLS1_2`
- Tags: (same as Resource Group)

## Usage

### Initialize Terraform
```bash
terraform init
```

### Validate Configuration
```bash
terraform validate
```

### Format Code
```bash
terraform fmt -recursive
```

### Plan Changes
```bash
terraform plan
```

**Note:** Running `terraform plan` should show **zero changes** as the code matches the current cloud state.

## Infrastructure Drift

This configuration was created/updated to resolve infrastructure drift detected on 2025-10-07. The Terraform code now accurately reflects the current state of deployed resources.

Any future changes to cloud resources should be made through Terraform to prevent drift.
