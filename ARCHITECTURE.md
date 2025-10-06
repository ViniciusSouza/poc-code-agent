# Infrastructure Architecture

## Azure Resources Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Azure Subscription                            │
│                 1b20e535-4f97-49d7-9cde-7a006ced003d            │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │
                ┌───────────────▼────────────────┐
                │   Resource Group                │
                │   rg-drift-test-{suffix}        │
                │                                 │
                │   Location: East US             │
                │   Tags:                         │
                │   - Environment: test           │
                │   - ManagedBy: terraform        │
                │   - Project: drift-detector-test│
                │   - Purpose: testing-drift...   │
                └───────────────┬─────────────────┘
                                │
                                │
                ┌───────────────▼─────────────────┐
                │   Storage Account                │
                │   stdrift{suffix}                │
                │                                  │
                │   Type: StorageV2                │
                │   Tier: Standard                 │
                │   Replication: LRS               │
                │   📌 min_tls_version: TLS1_2    │
                │   🔒 HTTPS Only: true            │
                │   🔒 Public Access: disabled     │
                │   🔒 Shared Keys: disabled       │
                │                                  │
                │   Tags: (same as RG)             │
                └───────────────┬─────────────────┘
                                │
                                │
                ┌───────────────▼─────────────────┐
                │   Blob Container                 │
                │   test-container                 │
                │                                  │
                │   Access: private                │
                └──────────────────────────────────┘
```

## Terraform Module Structure

```
.
├── azure.tf                    # Main configuration
├── variables.tf                # Input variables
├── outputs.tf                  # Output values
│
└── modules/
    ├── resource_group/         # Resource Group module
    │   ├── main.tf            # RG resource definition
    │   ├── variables.tf       # RG variables
    │   └── outputs.tf         # RG outputs
    │
    └── storage_account/        # Storage Account module
        ├── main.tf            # Storage + Container definitions
        ├── variables.tf       # Storage variables
        └── outputs.tf         # Storage outputs
```

## Resource Relationships

```
random_string.suffix
        │
        ├─────────────────────────┐
        │                         │
        ▼                         ▼
module.resource_group ──────▶ module.storage_account
        │                         │
        │                         │
        ├─ name                   ├─ depends on RG
        └─ location               ├─ uses RG name
                                  └─ uses RG location
```

## Drift Detection Flow

```
┌──────────────────┐
│  Actual Cloud    │
│  Infrastructure  │
└────────┬─────────┘
         │
         │ Drift Detection Scan
         │ (2025-10-06 16:38:42 UTC)
         │
         ▼
┌──────────────────┐
│  Drift Report    │
│  - 2 Modified    │
│  - Severity: Med │
└────────┬─────────┘
         │
         │ Analysis
         │
         ▼
┌──────────────────┐     ┌─────────────────────┐
│  Critical Issues │────▶│  TLS 1.0 → TLS 1.2 │
│  - TLS Version   │     │  SECURITY FIX!      │
│  - Wrong Tags    │     └─────────────────────┘
└────────┬─────────┘
         │
         │ Remediation
         │
         ▼
┌──────────────────┐
│  Terraform Code  │
│  Created in PR   │
└────────┬─────────┘
         │
         │ terraform apply
         │
         ▼
┌──────────────────┐
│  Infrastructure  │
│  Back in Sync    │
└──────────────────┘
```

## Changes Applied by Terraform

### Resource Group Tags

```diff
  tags = {
-   "DriftCreated" = "true"
-   "Environment"  = "production"
+   "Environment"  = "test"
-   "ManagedBy"    = "manual"
+   "ManagedBy"    = "terraform"
-   "ModifiedAt"   = "2025-10-06T15:56:18Z"
-   "ModifiedBy"   = "drift-script"
    "Project"      = "drift-detector-test"
    "Purpose"      = "testing-drift-detection"
  }
```

### Storage Account Configuration

```diff
  min_tls_version = "TLS1_0" → "TLS1_2"  # 🚨 CRITICAL SECURITY FIX
  
  tags = {
-   "DriftCreated" = "true"
-   "Environment"  = "production"
+   "Environment"  = "test"
-   "ManagedBy"    = "manual"
+   "ManagedBy"    = "terraform"
-   "ModifiedBy"   = "drift-script"
+   "Project"      = "drift-detector-test"
+   "Purpose"      = "testing-drift-detection"
  }
```

## Security Hardening

### Before (Drift State)
```
❌ TLS 1.0 (Vulnerable to BEAST/POODLE)
❌ Manual management
❌ Incorrect environment label
```

### After (Terraform Apply)
```
✅ TLS 1.2 (PCI-DSS compliant)
✅ Terraform managed
✅ Correct environment label
✅ HTTPS enforced
✅ Public access disabled
✅ Azure AD authentication
```

## Compliance Alignment

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| PCI-DSS (TLS 1.2+) | ✅ | min_tls_version = "TLS1_2" |
| HTTPS Only | ✅ | enable_https_traffic_only = true |
| Least Privilege | ✅ | shared_access_key_enabled = false |
| Data Privacy | ✅ | allow_nested_items_to_be_public = false |
| IaC Management | ✅ | All resources in Terraform |
| Consistent Tagging | ✅ | Standardized tags across resources |

## Resource Naming Convention

```
Pattern: {type}-{purpose}-{random-suffix}

Examples:
- rg-drift-test-rzcwnl          (Resource Group)
- stdriftrzcwnl                 (Storage Account - no hyphens)
- test-container                (Container)
```

## Tags Schema

```yaml
Environment:
  type: string
  values: [test, dev, staging, production]
  current: test

ManagedBy:
  type: string
  values: [terraform, manual]
  current: terraform

Project:
  type: string
  current: drift-detector-test

Purpose:
  type: string
  current: testing-drift-detection
```
