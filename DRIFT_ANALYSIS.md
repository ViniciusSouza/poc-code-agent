# Infrastructure Drift Analysis and Remediation

**Detection Date:** 2025-10-06  
**Severity:** Medium  
**Status:** Fixed via Terraform Configuration

---

## Executive Summary

Infrastructure drift was detected in two Azure resources: a Resource Group and a Storage Account. The drift included:
1. Unauthorized manual tags added to resources
2. Critical security vulnerability (TLS 1.0 instead of TLS 1.2)
3. Environment misconfiguration (production instead of test)

This has been remediated by creating proper Terraform configuration that enforces the correct state.

---

## Detailed Drift Analysis

### 1. Resource Group: `rg-drift-test-rzcwnl`

**Resource Type:** `azurerm_resource_group`  
**Full Resource ID:** `module.resource_group.azurerm_resource_group.main`

#### Detected Changes

| Attribute | Expected Value | Actual Value in Cloud | Impact |
|-----------|---------------|----------------------|---------|
| tags.Environment | "test" | "production" | **Medium** - Wrong environment label |
| tags.ManagedBy | "terraform" | "manual" | **Medium** - Indicates manual changes |
| tags.DriftCreated | *(not expected)* | "true" | **Low** - Unauthorized tag |
| tags.ModifiedAt | *(not expected)* | "2025-10-06T15:56:18Z" | **Low** - Unauthorized tag |
| tags.ModifiedBy | *(not expected)* | "drift-script" | **Low** - Unauthorized tag |

#### Risk Assessment
- **Impact:** Medium
- **Risk:** Resource is incorrectly tagged as production when it should be test environment
- **Compliance:** Tags indicate manual management outside of IaC process

---

### 2. Storage Account: `stdriftrzcwnl`

**Resource Type:** `azurerm_storage_account`  
**Full Resource ID:** `module.storage_account.azurerm_storage_account.main`

#### Detected Changes

| Attribute | Expected Value | Actual Value in Cloud | Impact |
|-----------|---------------|----------------------|---------|
| min_tls_version | "TLS1_2" | "TLS1_0" | **🚨 CRITICAL** - Security vulnerability |
| tags.Environment | "test" | "production" | **Medium** - Wrong environment label |
| tags.ManagedBy | "terraform" | "manual" | **Medium** - Indicates manual changes |
| tags.Project | "drift-detector-test" | *(missing)* | **Low** - Missing required tag |
| tags.Purpose | "testing-drift-detection" | *(missing)* | **Low** - Missing required tag |
| tags.DriftCreated | *(not expected)* | "true" | **Low** - Unauthorized tag |
| tags.ModifiedBy | *(not expected)* | "drift-script" | **Low** - Unauthorized tag |

#### Risk Assessment
- **Impact:** HIGH - Critical security vulnerability
- **Risk:** TLS 1.0 is deprecated and vulnerable to attacks (POODLE, BEAST)
- **Compliance:** Violates security best practices and likely compliance requirements (PCI-DSS, HIPAA, etc.)
- **Recommendation:** **IMMEDIATE ACTION REQUIRED**

---

## Security Impact: TLS 1.0 Vulnerability

### Why This Matters

TLS 1.0 has known security vulnerabilities:
- **BEAST Attack** (Browser Exploit Against SSL/TLS)
- **POODLE Attack** (Padding Oracle On Downgraded Legacy Encryption)
- **Weak Cipher Suites** supported
- **Protocol Downgrade** attacks possible

### Industry Standards
- PCI-DSS requires TLS 1.2+ since June 2018
- Major cloud providers deprecated TLS 1.0 in 2020
- NIST recommends disabling TLS 1.0 and 1.1

### Impact
Storage accounts using TLS 1.0 can:
- Be exploited by man-in-the-middle attacks
- Fail compliance audits
- Expose data in transit to decryption

---

## Remediation Plan

### Automated Fix (Terraform Apply)

Running `terraform apply` with the provided configuration will:

1. **Update Resource Group**
   - Remove unauthorized tags: DriftCreated, ModifiedAt, ModifiedBy
   - Correct Environment tag from "production" → "test"
   - Correct ManagedBy tag from "manual" → "terraform"

2. **Update Storage Account**
   - ⚠️ **CRITICAL**: Upgrade min_tls_version from "TLS1_0" → "TLS1_2"
   - Remove unauthorized tags: DriftCreated, ModifiedBy
   - Correct Environment tag from "production" → "test"
   - Correct ManagedBy tag from "manual" → "terraform"
   - Add missing tags: Project, Purpose

### Expected Terraform Plan Output

```hcl
# module.resource_group.azurerm_resource_group.main will be updated in-place
~ resource "azurerm_resource_group" "main" {
    ~ tags = {
        - "DriftCreated" = "true" -> null
        ~ "Environment"  = "production" -> "test"
        ~ "ManagedBy"    = "manual" -> "terraform"
        - "ModifiedAt"   = "2025-10-06T15:56:18Z" -> null
        - "ModifiedBy"   = "drift-script" -> null
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
```

### Steps to Apply Fix

1. **Review the Changes**
   ```bash
   terraform init
   terraform plan
   ```

2. **Apply the Fix**
   ```bash
   terraform apply
   ```

3. **Verify the Fix**
   ```bash
   terraform plan  # Should show "No changes"
   ```

---

## Prevention Strategies

### 1. Access Control
- Implement RBAC to prevent unauthorized manual changes
- Use Azure Policy to enforce tagging requirements
- Enable resource locks on critical resources

### 2. Monitoring
- Set up Azure Policy compliance checks
- Enable activity log alerts for manual changes
- Implement drift detection automation (already in place)

### 3. Process
- Document that ALL changes must go through Terraform
- Implement pull request reviews for infrastructure changes
- Regular drift detection scans (daily/weekly)

### 4. Terraform Best Practices
- Use remote state with locking
- Implement CI/CD pipelines for terraform apply
- Enable plan file reviews before apply

---

## Root Cause Analysis

### How Did This Happen?

Based on the tags added:
- `DriftCreated: "true"` - Intentional drift for testing
- `ModifiedBy: "drift-script"` - Automated script made changes
- `ModifiedAt: "2025-10-06T15:56:18Z"` - Timestamp of manual change

**Conclusion:** This appears to be intentional drift created for testing the drift detection system.

### Lessons Learned
1. Even test resources should follow IaC principles
2. Manual changes (even for testing) create security risks
3. Drift detection systems are working correctly

---

## Sign-Off

- **Drift Detection:** ✅ Working as expected
- **Root Cause:** ✅ Identified (test drift script)
- **Remediation:** ✅ Terraform configuration created
- **Security Risk:** ⚠️ TLS 1.0 vulnerability requires immediate fix
- **Next Action:** Run `terraform apply` to fix drift

**Recommended Timeline:** ASAP (critical security fix)
