# Quick Start: Fixing Infrastructure Drift

## Prerequisites
- Terraform >= 1.0 installed
- Azure CLI authenticated (`az login`)
- Appropriate permissions on Azure subscription

## Fix the Drift in 3 Steps

### Step 1: Initialize Terraform
```bash
cd /path/to/repository
terraform init
```

This will:
- Download required providers (azurerm, random)
- Initialize the backend
- Prepare modules

### Step 2: Review Changes
```bash
terraform plan
```

Expected output:
- 0 to add
- 2 to change (resource group and storage account)
- 0 to destroy

### Step 3: Apply the Fix
```bash
terraform apply
```

Type `yes` when prompted to confirm.

## What Gets Fixed?

### ✅ Resource Group
- Removes unauthorized drift tags
- Corrects Environment: production → test
- Corrects ManagedBy: manual → terraform

### ✅ Storage Account (CRITICAL)
- **Security Fix**: TLS1_0 → TLS1_2
- Removes unauthorized drift tags
- Corrects Environment: production → test
- Corrects ManagedBy: manual → terraform
- Adds missing Project and Purpose tags

## Verification

After applying, verify no drift remains:
```bash
terraform plan
```

Should output: **"No changes. Your infrastructure matches the configuration."**

## Troubleshooting

### "Error: Insufficient permissions"
- Ensure you have Contributor or Owner role on the subscription
- Run `az login` and select the correct subscription

### "Error: Backend initialization required"
- Run `terraform init` first

### "Terraform not found"
- Install Terraform: https://developer.hashicorp.com/terraform/install

## Important Notes

⚠️ This fix includes a **critical security update** (TLS 1.2 enforcement)  
⚠️ Tag changes will overwrite manual modifications  
⚠️ All changes are in-place updates (no resource recreation)

## Support

For issues or questions, see:
- [TERRAFORM.md](TERRAFORM.md) - Full documentation
- [DRIFT_ANALYSIS.md](DRIFT_ANALYSIS.md) - Detailed drift analysis
