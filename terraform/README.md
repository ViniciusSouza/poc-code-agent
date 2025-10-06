# Terraform Infrastructure for Drift Detection Test

This directory contains Terraform configuration files for managing Azure infrastructure with drift detection capabilities.

## Overview

The infrastructure consists of:
- **Resource Group**: Azure resource group for organizing resources
- **Storage Account**: Azure storage account with security best practices
  - Minimum TLS version: TLS 1.2 (security hardened)
  - HTTPS-only traffic enforcement
  - Shared access key disabled
  - Public blob access disabled
- **Storage Container**: Private blob storage container

## Structure

```
terraform/
├── azure.tf                          # Main configuration file
├── variables.tf                      # Input variables
├── outputs.tf                        # Output values
└── modules/
    ├── resource-group/               # Resource group module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── storage-account/              # Storage account module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Drift Resolution

This Terraform configuration addresses the following infrastructure drift issues detected on 2025-10-06:

### 🔴 Security Issues (Critical)
- **Storage Account TLS Version**: Cloud state had `TLS1_0` (insecure), corrected to `TLS1_2`
  - **Risk**: Using TLS 1.0 exposes data to known security vulnerabilities
  - **Fix**: Explicitly set `min_tls_version = "TLS1_2"` in storage account configuration

### 🟡 Configuration Drift (Medium)
- **Resource Group Tags**: Tags were manually modified in Azure portal
  - **Before**: `Environment=production`, `ManagedBy=manual`, extra drift tracking tags
  - **After**: `Environment=test`, `ManagedBy=terraform` (correct state)
  
- **Storage Account Tags**: Tags were manually modified 
  - **Before**: `Environment=production`, `ManagedBy=manual`, missing Project/Purpose tags
  - **After**: Complete tag set matching resource group

## Usage

### Prerequisites
- Terraform >= 1.0
- Azure CLI authenticated (`az login`)
- Appropriate Azure subscription access

### Initialize Terraform
```bash
cd terraform
terraform init
```

### Plan Changes
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply
```

This will:
1. Update resource group tags to match Terraform state
2. Update storage account to enforce TLS 1.2
3. Update storage account tags to match Terraform state

### Verify Drift Resolution
```bash
terraform plan
```

Should show: "No changes. Your infrastructure matches the configuration."

## Important Notes

⚠️ **Security Considerations**:
- The storage account is configured with security best practices
- TLS 1.2 is the minimum supported version (industry standard)
- Shared access keys are disabled; use Azure AD authentication
- Public blob access is disabled for enhanced security

✅ **Safe to Apply**:
- Only tags and TLS version will be updated
- No resource recreation required
- No data loss or downtime expected
- Changes are non-destructive

⚠️ **Manual Review Required**:
- If you need TLS 1.0 support (legacy systems), this must be explicitly approved
- Verify that all applications support TLS 1.2 before applying

## Tagging Strategy

All resources are tagged with:
- `Environment`: Deployment environment (test/staging/production)
- `ManagedBy`: terraform (indicates IaC management)
- `Project`: drift-detector-test
- `Purpose`: testing-drift-detection

## Contributing

When making infrastructure changes:
1. Always run `terraform plan` first
2. Review drift detection reports
3. Update this README if adding new resources
4. Ensure tags are consistent across all resources
