---
name: OCI Vault and Secrets Management
description: Use when storing credentials in OCI Vault, troubleshooting secret retrieval failures, implementing secret rotation, or setting up application authentication to Vault. Covers vault hierarchy confusion, IAM permission gotchas, cost optimization, temp file security, and audit logging. Keywords: vault secret, 403 forbidden, secret retrieval, instance principal, base64 encoding, secret rotation.
version: 2.0.0
---

# OCI Vault and Secrets Management - Expert Knowledge

You are an OCI Vault expert. This skill provides knowledge Claude lacks: anti-patterns, IAM permission gotchas, cost optimization, security vulnerabilities, and OCI-specific operational knowledge.

## NEVER Do This

❌ **NEVER log secret contents (even in debug/error messages)**
```python
# WRONG - secret ends up in log aggregation, retained for years
logger.debug(f"Retrieved secret: {secret_value}")
logger.error(f"Failed to parse secret: {secret_value}")

# RIGHT - log metadata only
logger.debug(f"Retrieved secret OCID: {secret_ocid[:20]}...")
logger.error(f"Failed to parse secret (type: {type(secret_value)})")
```

❌ **NEVER set temp key file permissions AFTER writing content**
```python
# WRONG - world-readable during write (security window)
with open('/tmp/key.pem', 'w') as f:
    f.write(private_key)
os.chmod('/tmp/key.pem', 0o600)  # Too late!

# RIGHT - secure BEFORE writing
fd = os.open('/tmp/key.pem', os.O_CREAT | os.O_WRONLY, 0o600)
with os.fdopen(fd, 'w') as f:
    f.write(private_key)
```

❌ **NEVER use overly broad IAM policies**
```
BAD:  "Allow any-user to read secret-family in tenancy"
BAD:  "Allow group Developers to manage secret-family in tenancy"
GOOD: "Allow dynamic-group app-prod to read secret-family in compartment AppSecrets
       where target.secret.name = 'db-*'"
```

❌ **NEVER retrieve secrets without caching**
- **Cost**: $0.03 per 10,000 requests (first 10k/month free)
- **Without cache**: 1000 req/hr × 24 × 30 = 720k/month = **$2.16/month**
- **With 60min cache**: 1000 req/hr → 24 calls/day = 720/month = **FREE**
- **Savings**: 98% cost reduction

❌ **NEVER use PLAIN content type (deprecated)**
- Always use BASE64 encoding for secrets
- PLAIN is legacy and may not work in future

❌ **NEVER hardcode Vault OCIDs in code**
```python
# WRONG - not portable, leaked in repos
VAULT_SECRET_OCID = "ocid1.vaultsecret.oc1.iad.xxxxx"

# RIGHT - configuration
VAULT_SECRET_OCID = os.environ['VAULT_SECRET_OCID']
```

## IAM Permission Gotcha (Critical)

Secret retrieval requires **BOTH** permissions:

```
"Allow dynamic-group X to read secret-family in compartment Y"
"Allow dynamic-group X to use keys in compartment Y"
```

**Why both needed:**
- `read secret-family` → allows listing and reading secret metadata
- `use keys` → allows decryption of secret content (secrets encrypted with master key)

**Without `use keys`**: Get confusing 403 error: "User not authorized to perform this operation"

**Common mistake**: Forgetting `use keys` permission, spending hours debugging "authorization failed"

## Vault Hierarchy (Often Confused)

```
Vault (container)
 └─ Master Encryption Key (for encryption/decryption)
     └─ Secret (encrypted data)
         └─ Secret Versions (rotation over time)
```

**Commands use different services:**
- Vault operations: `oci kms management vault ...`
- Key operations: `oci kms management key ... --endpoint <vault-endpoint>`
- Secret operations: `oci vault secret ...` (NOT kms!)

**Common mistake**: `oci vault-secret create` (no such command) vs `oci vault secret create` (correct)

## Secret Retrieval Error Decision Tree

```
Secret retrieval fails?
│
├─ 401 Unauthorized
│  ├─ On OCI compute? → Check dynamic group membership
│  ├─ Local dev? → Check ~/.oci/config, verify API key uploaded
│  └─ After rotation? → Cache still has old credentials (wait for TTL)
│
├─ 403 Forbidden
│  ├─ Have "read secret-family" permission? → Add if missing
│  └─ Have "use keys" permission? → THIS IS USUALLY THE ISSUE
│
├─ 404 Not Found
│  ├─ Wrong secret OCID? → Verify environment variable
│  ├─ Wrong compartment? → Secrets client must use secret's compartment
│  └─ Secret deleted? → Check vault for secret status
│
└─ 500 Internal Server Error
   └─ Vault service issue → Retry with exponential backoff (rate limit)
```

## Cost Optimization

**Vault API Pricing:** $0.03 per 10,000 requests (10k/month free)

### Calculation Examples:

**Without caching** (retrieve on every API call):
- 1000 API calls/hour
- 24 hours × 30 days = 720,000 Vault requests/month
- (720,000 / 10,000) × $0.03 = **$2.16/month**

**With 60-minute cache TTL**:
- 1000 API calls/hour → 1 Vault request/hour
- 24 hours × 30 days = 720 Vault requests/month
- Under 10k free tier = **$0/month (FREE)**
- **Savings: 98%**

**Cache TTL Selection:**

| Security Requirements | Cache TTL | Reasoning |
|----------------------|-----------|-----------|
| High (rotate daily) | 5-15 minutes | Frequent refresh, still 90%+ savings |
| Standard (rotate monthly) | 30-60 minutes | Balance security and cost |
| Dev/Test | No cache | Always fresh for development |

**Rule**: Cache TTL must be **less than** secret rotation window

## Secret Rotation (Zero-Downtime)

**WRONG** (causes downtime):
```bash
# Don't delete and recreate - breaks running apps
oci vault secret delete --secret-id <secret-ocid>
oci vault secret create ...  # New OCID, apps break
```

**RIGHT** (zero-downtime):
```bash
# Create new VERSION of existing secret
oci vault secret update-base64 \
  --secret-id <secret-ocid> \
  --secret-content-content "$(echo -n 'new-value' | base64)"

# Secret OCID stays same, apps automatically get new version
# Old version kept as "previous" for rollback
```

**Key points:**
- Secret OCID doesn't change (apps continue working)
- Vault serves latest version by default
- Previous versions retained for rollback
- Applications pick up new version on next cache refresh (no restart needed)

## Instance Principal Authentication

**Production compute instances should use instance principals:**

```bash
# 1. Create dynamic group
oci iam dynamic-group create \
  --name "app-instances" \
  --matching-rule "instance.compartment.id = '<compartment-ocid>'"

# 2. Grant Vault access
# "Allow dynamic-group app-instances to read secret-family in compartment Secrets"
# "Allow dynamic-group app-instances to use keys in compartment Secrets"

# 3. Application code (no credentials needed)
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
secrets_client = oci.secrets.SecretsClient(config={}, signer=signer)
```

**Benefits:**
- No credentials to manage or rotate
- No secrets stored on compute instances
- Automatic token refresh
- Audit trail shows which instance accessed what

## Audit Logging

**Enable Vault access logging:**

```bash
# Create log group
oci logging log-group create \
  --compartment-id <ocid> \
  --display-name "vault-audit-logs"

# Enable read access logging
oci logging log create \
  --log-group-id <log-group-ocid> \
  --display-name "secret-read-audit" \
  --log-type SERVICE \
  --configuration '{
    "source": {
      "sourceType": "OCISERVICE",
      "service": "vaults",
      "resource": "<vault-ocid>",
      "category": "read"
    }
  }'
```

**What gets logged:**
- Who: User OCID or instance principal identity
- What: Secret OCID accessed
- When: Timestamp (UTC)
- Where: Source IP address
- Result: Success (200) or failure (403, 404, etc.)

**Monitoring alerts** (recommended):
- \>10 failed access attempts in 5 minutes (unauthorized access)
- Access to secrets not assigned to requesting instance
- Access from unexpected IP ranges

## OCI-Specific Gotchas

**Vault Management Endpoint is Required for Key Operations:**
```bash
# Find your vault's endpoint
oci kms management vault get --vault-id <vault-ocid> \
  --query 'data."management-endpoint"' --raw-output

# Use in key commands
oci kms management key create ... \
  --endpoint https://xxxxx-management.kms.us-ashburn-1.oraclecloud.com
```

**Regional Vault Availability:**
- Not all OCI regions have Vault service
- Check region availability before designing architecture
- Cross-region secret access adds latency (10-50ms)

**Secret Bundle Base64 Decoding:**
```python
# Secret content is base64-encoded
secret_bundle = secrets_client.get_secret_bundle(secret_ocid)
encoded = secret_bundle.data.secret_bundle_content.content
decoded = base64.b64decode(encoded).decode('utf-8')  # Don't forget decode()
```

## When to Use This Skill

- Storing credentials in Vault: secret organization, IAM setup
- Secret retrieval failures: 403 errors, permission debugging
- Cost optimization: caching strategy, API call reduction
- Secret rotation: zero-downtime updates, version management
- Security: temp file handling, logging anti-patterns, audit setup
- Production: instance principal configuration, monitoring alerts
