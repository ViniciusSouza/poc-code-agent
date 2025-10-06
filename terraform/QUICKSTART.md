# Quick Start - Apply Drift Fix

This guide shows how to apply the Terraform configuration to fix the detected infrastructure drift.

## Prerequisites

✅ Ensure you have:
- Terraform >= 1.0 installed
- Azure CLI installed and authenticated (`az login`)
- Appropriate permissions on the Azure subscription

## Step 1: Navigate to Terraform Directory

```bash
cd terraform
```

## Step 2: Initialize Terraform

```bash
terraform init
```

**Expected output:**
```
Initializing modules...
Initializing provider plugins...
Terraform has been successfully initialized!
```

## Step 3: Review the Planned Changes

```bash
terraform plan
```

**Expected changes:**
- ✅ Update resource group tags (Environment: production → test, ManagedBy: manual → terraform)
- ✅ Update storage account min_tls_version (TLS1_0 → TLS1_2) 🔒 **SECURITY FIX**
- ✅ Update storage account tags (same as resource group)
- ✅ No resources will be destroyed or recreated

**Sample output:**
```
Plan: 0 to add, 2 to change, 0 to destroy.

Changes will be performed to:
  ~ module.resource_group.azurerm_resource_group.main
  ~ module.storage_account.azurerm_storage_account.main
```

## Step 4: Apply the Fix

```bash
terraform apply
```

Type `yes` when prompted to confirm.

**Expected output:**
```
Apply complete! Resources: 0 added, 2 changed, 0 destroyed.
```

## Step 5: Verify Drift is Resolved

```bash
terraform plan
```

**Expected output:**
```
No changes. Your infrastructure matches the configuration.
```

✅ **Drift is now resolved!**

## What Was Fixed?

### 🔴 Critical Security Issue (FIXED)
- **Storage Account TLS Version**: Upgraded from insecure TLS 1.0 to secure TLS 1.2
- **Impact**: Protects data in transit from known vulnerabilities

### 🟡 Configuration Issues (FIXED)
- **Resource Group Tags**: Corrected to proper environment (test) and management (terraform)
- **Storage Account Tags**: Added missing tags and corrected environment/management

## Rollback (if needed)

If you need to rollback for any reason:

```bash
# This will show you the previous state
terraform show

# To import existing resources to match current cloud state
terraform import module.resource_group.azurerm_resource_group.main /subscriptions/1b20e535-4f97-49d7-9cde-7a006ced003d/resourceGroups/rg-drift-test-rzcwnl

terraform import module.storage_account.azurerm_storage_account.main /subscriptions/1b20e535-4f97-49d7-9cde-7a006ced003d/resourceGroups/rg-drift-test-rzcwnl/providers/Microsoft.Storage/storageAccounts/stdriftrzcwnl
```

⚠️ **Note**: Rolling back the TLS version to 1.0 is **not recommended** due to security concerns.

## Troubleshooting

### Issue: "Error: Insufficient permissions"
**Solution**: Ensure your Azure account has Contributor or Owner role on the subscription.

### Issue: "Error: Resource already exists"
**Solution**: The resources already exist (expected). Terraform will update them in place.

### Issue: Applications fail after TLS 1.2 upgrade
**Solution**: 
1. Check application logs for TLS errors
2. Verify applications support TLS 1.2
3. Update application dependencies if needed
4. TLS 1.2 has been industry standard since 2008 - all modern applications should support it

## Next Steps

1. ✅ Monitor applications for any issues post-deployment
2. ✅ Set up CI/CD pipeline to run `terraform plan` on schedule
3. ✅ Configure Azure Policy to prevent manual changes
4. ✅ Enable drift detection automation
5. ✅ Document any exceptions or special cases

## Need Help?

- 📖 See [terraform/README.md](README.md) for detailed documentation
- 📊 See [terraform/DRIFT_ANALYSIS.md](DRIFT_ANALYSIS.md) for drift analysis details
- 🔧 Check Terraform logs: `TF_LOG=DEBUG terraform plan`

---

**Status**: ✅ Ready to apply  
**Risk Level**: Low (in-place updates only)  
**Downtime**: None expected  
**Data Loss**: None expected
