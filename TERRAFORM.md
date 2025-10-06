# Azure Infrastructure Configuration

This directory contains Terraform configuration for Azure infrastructure to prevent drift.

## Overview

This configuration creates and manages:
- Azure Resource Group with proper tags
- Azure Storage Account with security best practices
- Storage Container for testing

## Security Features

The configuration enforces security best practices:
- **TLS 1.2 minimum version** - protects against protocol downgrade attacks
- **HTTPS-only traffic** - prevents unencrypted communication
- **Private blob access** - prevents public data exposure
- **Azure AD authentication** - uses modern authentication instead of shared keys

## Drift Prevention

This configuration is designed to prevent infrastructure drift by:
1. Explicitly defining all resource properties
2. Using consistent tagging across all resources
3. Enforcing security settings that match compliance requirements

## Tags

All resources are tagged with:
- `Environment`: test
- `ManagedBy`: terraform
- `Project`: drift-detector-test
- `Purpose`: testing-drift-detection

## Usage

### Prerequisites
- Terraform >= 1.0
- Azure CLI configured with appropriate credentials
- Appropriate Azure subscription permissions

### Initialize Terraform
```bash
terraform init
```

### Plan Changes
```bash
terraform plan
```

### Apply Changes
```bash
terraform apply
```

## Fixing Drift

If drift is detected:
1. Review the drift report to understand what changed
2. Run `terraform plan` to see the differences
3. Run `terraform apply` to bring infrastructure back to desired state

## Important Notes

⚠️ **Security Alert**: This configuration fixes a critical security issue where the storage account was using TLS 1.0. The configuration enforces TLS 1.2 minimum.

⚠️ **Tag Management**: Manual tag changes in Azure will be overwritten by Terraform to maintain consistency.
