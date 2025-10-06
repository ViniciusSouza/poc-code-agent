# Drift Remediation Checklist

## Pre-Apply Verification

- [x] Terraform configuration created
  - [x] azure.tf (main configuration)
  - [x] variables.tf (input variables)
  - [x] outputs.tf (output values)
  - [x] Resource group module
  - [x] Storage account module

- [x] Documentation complete
  - [x] QUICKSTART.md (quick remediation guide)
  - [x] TERRAFORM.md (detailed infrastructure docs)
  - [x] DRIFT_ANALYSIS.md (drift analysis and risk assessment)
  - [x] README.md updated with infrastructure status

- [x] Security fixes included
  - [x] TLS 1.2 enforcement (fixes TLS 1.0 vulnerability)
  - [x] HTTPS-only traffic
  - [x] Disabled public blob access
  - [x] Azure AD authentication enabled

- [x] Tag fixes included
  - [x] Environment: "test" (correct from "production")
  - [x] ManagedBy: "terraform" (correct from "manual")
  - [x] Project: "drift-detector-test"
  - [x] Purpose: "testing-drift-detection"
  - [x] Remove unauthorized tags: DriftCreated, ModifiedAt, ModifiedBy

## Apply Process

### Step 1: Initialize (Required)
```bash
terraform init
```
- [ ] Providers downloaded successfully
- [ ] Modules initialized
- [ ] Backend configured

### Step 2: Plan (Review)
```bash
terraform plan
```
- [ ] Plan shows 2 resources to update
- [ ] No resources to create or destroy
- [ ] Changes match expected drift fixes
- [ ] TLS version change visible (TLS1_0 → TLS1_2)
- [ ] Tag changes visible

### Step 3: Apply (Execute)
```bash
terraform apply
```
- [ ] Review plan output
- [ ] Type "yes" to confirm
- [ ] Apply completes successfully
- [ ] 2 resources updated

### Step 4: Verify (Validate)
```bash
terraform plan
```
- [ ] Output: "No changes. Your infrastructure matches the configuration."
- [ ] No drift detected

## Post-Apply Verification

### Azure Portal Checks
- [ ] Resource Group tags are correct
  - [ ] Environment = "test"
  - [ ] ManagedBy = "terraform"
  - [ ] Project = "drift-detector-test"
  - [ ] Purpose = "testing-drift-detection"
  - [ ] No DriftCreated, ModifiedAt, ModifiedBy tags

- [ ] Storage Account configuration is correct
  - [ ] min_tls_version = "TLS1_2"
  - [ ] Tags match resource group
  - [ ] Container "test-container" exists

### Security Validation
- [ ] Storage account only accepts TLS 1.2+ connections
- [ ] HTTPS is enforced
- [ ] Public blob access is disabled

## Expected Terraform Plan Output

```hcl
Terraform will perform the following actions:

  # module.resource_group.azurerm_resource_group.main will be updated in-place
  ~ resource "azurerm_resource_group" "main" {
      ~ tags = {
          - "DriftCreated" = "true" -> null
          ~ "Environment"  = "production" -> "test"
          ~ "ManagedBy"    = "manual" -> "terraform"
          - "ModifiedAt"   = "2025-10-06T15:56:18Z" -> null
          - "ModifiedBy"   = "drift-script" -> null
            # (2 unchanged elements)
        }
    }

  # module.storage_account.azurerm_storage_account.main will be updated in-place
  ~ resource "azurerm_storage_account" "main" {
      ~ min_tls_version = "TLS1_0" -> "TLS1_2"
      ~ tags = {
          - "DriftCreated" = "true" -> null
          ~ "Environment"  = "production" -> "test"
          ~ "ManagedBy"    = "manual" -> "terraform"
          - "ModifiedBy"   = "drift-script" -> null
          + "Project"      = "drift-detector-test"
          + "Purpose"      = "testing-drift-detection"
        }
    }

Plan: 0 to add, 2 to change, 0 to destroy.
```

## Rollback Plan

If issues occur during apply:

1. **Terraform State**
   - State is safely stored
   - Previous state backed up automatically

2. **Resource Recovery**
   - Resources are only updated, not recreated
   - No data loss risk
   - Can revert individual attributes via Azure Portal if needed

3. **Manual Reversion**
   - If needed, manually set tags back in Azure Portal
   - Run `terraform refresh` to sync state
   - Review and reapply

## Sign-Off

**Ready for Apply:** ✅ YES

All configuration files are in place, documentation is complete, and the remediation plan addresses all detected drift issues including the critical TLS security vulnerability.

**Next Action:** Run `terraform apply` to fix the drift.

---

**Created:** 2025-10-06  
**Author:** GitHub Copilot  
**Version:** 1.0
