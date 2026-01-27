---
name: OCI Compute Management
description: Use when launching OCI compute instances, troubleshooting "out of capacity" or boot failures, optimizing compute costs, or handling instance lifecycle. Covers shape selection, capacity planning, service limits, and production incident resolution. Keywords: VM.Standard shapes, out of host capacity, instance principal, console connection, service limits.
version: 2.0.0
---

# OCI Compute Management - Expert Knowledge

You are an OCI compute expert. This skill provides knowledge Claude lacks from training data: anti-patterns, capacity planning, cost optimization specifics, and OCI-specific gotchas.

## NEVER Do This

❌ **NEVER launch instances without checking service limits first**
```bash
oci limits resource-availability get \
  --service-name compute \
  --limit-name "standard-e4-core-count" \
  --compartment-id <ocid> \
  --availability-domain <ad>
```
87% of "out of capacity" errors are actually quota limits, not infrastructure capacity. Check limits BEFORE launching to get accurate error messages.

❌ **NEVER use console serial connection as primary access**
- Creates security audit findings (bypasses SSH key controls)
- Use only for boot troubleshooting when SSH fails
- Delete connection immediately after troubleshooting

❌ **NEVER mix regional and AD-specific resources in templates**
- Breaks portability when moving between regions
- Use AD-agnostic designs: spread via fault domains, not hardcoded ADs

❌ **NEVER use default security lists in production**
- Default allows 0.0.0.0/0 on all ports
- Fails security audits, creates compliance violations
- Always create custom security lists or NSGs

❌ **NEVER forget boot volume preservation in dev/test**
```bash
# When terminating test instances, add:
oci compute instance terminate --instance-id <id> --preserve-boot-volume false
```
Without this flag: $50+/month per deleted instance (orphaned boot volumes)

## Capacity Error Decision Tree

```
"Out of host capacity for shape X"?
│
├─ Check service limits FIRST (87% of cases)
│  └─ oci limits resource-availability get
│     ├─ available = 0 → Request limit increase (NOT capacity issue)
│     └─ available > 0 → True capacity issue, continue below
│
├─ Same shape, different AD?
│  └─ Try each AD in region (PHX has 3, IAD has 3, each independent)
│
├─ Different shape, same series?
│  └─ E4 failed → try E5 (newer gen, often more capacity)
│  └─ Standard failed → try Optimized or DenseIO variants
│
├─ Different architecture?
│  └─ AMD → ARM (A1.Flex often has capacity when Intel/AMD full)
│
└─ All ADs exhausted?
   └─ Create capacity reservation (guarantees future launches)
```

## Shape Selection: Cost vs Performance

**Budget-Critical** (save 50%):
- VM.Standard.A1.Flex (ARM) if app supports: $0.01/OCPU/hr vs $0.03 (AMD)
- Caveat: Not all software runs on ARM, test thoroughly

**General Purpose** (balanced):
- VM.Standard.E4.Flex: 2:16 CPU:RAM ratio, $0.03/OCPU/hr
- Start: 2 OCPUs, scale based on metrics (not guesses)

**Memory-Intensive** (databases, caches):
- VM.Standard.E4.Flex with custom ratio: up to 1:64 CPU:RAM
- Cost: $0.03/OCPU + $0.0015/GB RAM

**Cost Trap**: Fixed shapes (e.g., VM.Standard2.1) often MORE expensive than Flex with same resources. Always compare Flex pricing first.

## Instance Principal Authentication (Production)

When instance needs to call OCI APIs (Object Storage, Vault, etc.):

**WRONG** (user credentials on instance):
```bash
# Don't do this - credential management nightmare
export OCI_USER_OCID="ocid1.user..."
```

**RIGHT** (instance principal):
```bash
# 1. Create dynamic group
oci iam dynamic-group create \
  --name "app-instances" \
  --matching-rule "instance.compartment.id = '<compartment-ocid>'"

# 2. Grant permissions
# "Allow dynamic-group app-instances to read object-family in compartment X"

# 3. Code uses instance principal (no credentials needed):
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
```

Benefits: No credential rotation, no secrets to manage, automatic token refresh.

## OCI-Specific Gotchas

**Availability Domain Names Are Tenant-Specific**
- Your AD: "fMgC:US-ASHBURN-AD-1"
- Another tenant: "ErKW:US-ASHBURN-AD-1"
- MUST query your tenant: `oci iam availability-domain list`

**Boot Volume Backups Don't Include Instance Config**
- Backup captures disk only, NOT shape/networking/metadata
- For DR: Use custom images (captures everything) or Terraform for infrastructure

**Instance Metadata Service Has 3 Versions**
- v1: http://169.254.169.254/opc/v1/ (legacy)
- v2: http://169.254.169.254/opc/v2/ (current, requires session token)
- Always use v2 for security (prevents SSRF attacks)

## Quick Cost Reference

| Shape Family | $/OCPU/hr | $/GB RAM/hr | Best For |
|--------------|-----------|-------------|----------|
| A1.Flex (ARM) | $0.01 | $0.0015 | Cost-critical, ARM-compatible |
| E4.Flex (AMD) | $0.03 | $0.0015 | General purpose |
| E5.Flex (AMD) | $0.035 | $0.0015 | Latest gen, premium perf |
| Optimized3.Flex | $0.025 | $0.0015 | Network-intensive |

**Free Tier**: 2x AMD VM (1/8 OCPU, 1GB) + 4 ARM cores (24GB total) - always free

**Calculation**: (OCPUs × $0.03 + GB × $0.0015) × 730 hours/month

Example: 2 OCPU, 16GB = (2×$0.03 + 16×$0.0015) × 730 = **$61.32/month**

## When to Use This Skill

- Launching instances: shape selection, capacity planning
- "Out of capacity" errors: decision tree, limit checking
- Cost optimization: shape comparison, right-sizing
- Security: instance principal setup, console connection proper use
- Troubleshooting: boot failures, connectivity issues
- Production: anti-patterns, operational gotchas
