---
name: OCI Vault and Secrets Management
description: Manage secrets, encryption keys, and certificates using Oracle Cloud Infrastructure Vault service. Complete CLI reference for secure credential storage and key management.
version: 1.0.0
---

# OCI Vault and Secrets Management Skill

You are an expert in Oracle Cloud Infrastructure Vault service for secrets management and encryption key management. This skill provides comprehensive CLI commands to compensate for Claude's limited OCI training data.

## Core Vault Services

### Vault Service
- Create and manage vaults for key and secret storage
- Virtual private vaults for isolated key management
- Master encryption keys for data encryption

### Key Management
- Create and manage encryption keys (AES, RSA)
- Key rotation and versioning
- Import external keys (BYOK - Bring Your Own Key)

### Secrets Management
- Store sensitive information (passwords, tokens, certificates)
- Secret rotation and versioning
- Secure secret retrieval for applications

## Vault Management CLI Commands

### Creating and Managing Vaults
```bash
# List all vaults in compartment
oci kms management vault list \
  --compartment-id <compartment-ocid>

# Get vault details
oci kms management vault get \
  --vault-id <vault-ocid>

# Create a new vault
oci kms management vault create \
  --compartment-id <compartment-ocid> \
  --display-name "ProductionVault" \
  --vault-type DEFAULT

# Create virtual private vault (more isolation)
oci kms management vault create \
  --compartment-id <compartment-ocid> \
  --display-name "HighSecurityVault" \
  --vault-type VIRTUAL_PRIVATE

# Update vault display name
oci kms management vault update \
  --vault-id <vault-ocid> \
  --display-name "NewVaultName"

# Schedule vault deletion (7-30 days)
oci kms management vault schedule-deletion \
  --vault-id <vault-ocid> \
  --time-of-deletion "2024-02-26T00:00:00Z"

# Cancel scheduled vault deletion
oci kms management vault cancel-deletion \
  --vault-id <vault-ocid>
```

## Encryption Key Management

### Master Encryption Keys
```bash
# List keys in vault
oci kms management key list \
  --compartment-id <compartment-ocid> \
  --endpoint <vault-management-endpoint>

# Get key details
oci kms management key get \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>

# Create AES encryption key
oci kms management key create \
  --compartment-id <compartment-ocid> \
  --display-name "DatabaseEncryptionKey" \
  --key-shape '{"algorithm":"AES","length":32}' \
  --endpoint <vault-management-endpoint>

# Create RSA key
oci kms management key create \
  --compartment-id <compartment-ocid> \
  --display-name "SigningKey" \
  --key-shape '{"algorithm":"RSA","length":256}' \
  --endpoint <vault-management-endpoint>

# Update key display name
oci kms management key update \
  --key-id <key-ocid> \
  --display-name "NewKeyName" \
  --endpoint <vault-management-endpoint>

# Enable/disable key
oci kms management key enable \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>

oci kms management key disable \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>

# Schedule key deletion (7-30 days minimum)
oci kms management key schedule-deletion \
  --key-id <key-ocid> \
  --time-of-deletion "2024-02-26T00:00:00Z" \
  --endpoint <vault-management-endpoint>

# Cancel scheduled key deletion
oci kms management key cancel-deletion \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>
```

### Key Versions and Rotation
```bash
# List key versions
oci kms management key-version list \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>

# Get key version details
oci kms management key-version get \
  --key-id <key-ocid> \
  --key-version-id <version-ocid> \
  --endpoint <vault-management-endpoint>

# Create new key version (rotation)
oci kms management key-version create \
  --key-id <key-ocid> \
  --endpoint <vault-management-endpoint>

# Schedule key version deletion
oci kms management key-version schedule-deletion \
  --key-id <key-ocid> \
  --key-version-id <version-ocid> \
  --time-of-deletion "2024-02-26T00:00:00Z" \
  --endpoint <vault-management-endpoint>
```

### Encryption and Decryption Operations
```bash
# Encrypt data using key
oci kms crypto encrypt \
  --key-id <key-ocid> \
  --plaintext "$(echo -n 'Sensitive data' | base64)" \
  --endpoint <vault-crypto-endpoint>

# Decrypt data
oci kms crypto decrypt \
  --key-id <key-ocid> \
  --ciphertext "<encrypted-data>" \
  --endpoint <vault-crypto-endpoint>

# Generate data encryption key (DEK)
oci kms crypto generate-data-encryption-key \
  --key-id <key-ocid> \
  --include-plaintext-key true \
  --endpoint <vault-crypto-endpoint>
```

## Secrets Management

### Creating and Managing Secrets
```bash
# List secrets in vault
oci vault secret list \
  --compartment-id <compartment-ocid>

# Get secret metadata (not the actual secret)
oci vault secret get \
  --secret-id <secret-ocid>

# Create a secret (plain text)
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "database-password" \
  --secret-content-content "$(echo -n 'MySecurePassword123!' | base64)"

# Create secret from file
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "api-key" \
  --secret-content-content "$(base64 < api-key.txt)"

# Update secret description
oci vault secret update \
  --secret-id <secret-ocid> \
  --description "Updated database password for production"

# Update secret metadata
oci vault secret update \
  --secret-id <secret-ocid> \
  --metadata '{"environment":"production","app":"myapp"}'

# Schedule secret deletion
oci vault secret schedule-secret-deletion \
  --secret-id <secret-ocid> \
  --time-of-deletion "2024-02-26T00:00:00Z"

# Cancel scheduled deletion
oci vault secret cancel-secret-deletion \
  --secret-id <secret-ocid>
```

### Secret Versions and Rotation
```bash
# List secret versions
oci secrets secret-version list \
  --secret-id <secret-ocid>

# Create new secret version (rotation)
oci vault secret update-base64 \
  --secret-id <secret-ocid> \
  --secret-content-content "$(echo -n 'NewPassword123!' | base64)"

# Get secret bundle (retrieve actual secret value)
oci secrets secret-bundle get \
  --secret-id <secret-ocid>

# Get specific secret version
oci secrets secret-bundle get \
  --secret-id <secret-ocid> \
  --version-number 2

# Get secret by name (latest version)
oci secrets secret-bundle get-secret-bundle-by-name \
  --secret-name "database-password" \
  --vault-id <vault-ocid>

# Extract secret value from response
oci secrets secret-bundle get \
  --secret-id <secret-ocid> \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d

# Schedule secret version deletion
oci vault secret-version schedule-secret-version-deletion \
  --secret-id <secret-ocid> \
  --secret-version-number 1 \
  --time-of-deletion "2024-02-26T00:00:00Z"
```

## Practical Usage Patterns

### Storing Database Credentials
```bash
# 1. Create vault (if not exists)
VAULT_ID=$(oci kms management vault create \
  --compartment-id $COMPARTMENT_ID \
  --display-name "AppVault" \
  --vault-type DEFAULT \
  --query 'data.id' \
  --raw-output)

# Wait for vault to become active
oci kms management vault get --vault-id $VAULT_ID --wait-for-state ACTIVE

# 2. Get vault management endpoint
MGMT_ENDPOINT=$(oci kms management vault get \
  --vault-id $VAULT_ID \
  --query 'data."management-endpoint"' \
  --raw-output)

# 3. Create encryption key
KEY_ID=$(oci kms management key create \
  --compartment-id $COMPARTMENT_ID \
  --display-name "SecretEncryptionKey" \
  --key-shape '{"algorithm":"AES","length":32}' \
  --endpoint $MGMT_ENDPOINT \
  --query 'data.id' \
  --raw-output)

# Wait for key to become enabled
oci kms management key get \
  --key-id $KEY_ID \
  --endpoint $MGMT_ENDPOINT \
  --wait-for-state ENABLED

# 4. Store database password
SECRET_ID=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --secret-name "prod-db-password" \
  --secret-content-content "$(echo -n 'MyDbPassword123!' | base64)" \
  --description "Production database password" \
  --query 'data.id' \
  --raw-output)

# 5. Retrieve password in application
DB_PASSWORD=$(oci secrets secret-bundle get \
  --secret-id $SECRET_ID \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d)
```

### Storing API Keys and Tokens
```bash
# Store GitHub personal access token
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "github-pat" \
  --secret-content-content "$(echo -n 'ghp_xxxxxxxxxxxx' | base64)" \
  --metadata '{"service":"github","scope":"repo"}'

# Store Slack webhook URL
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "slack-webhook" \
  --secret-content-content "$(echo -n 'https://hooks.slack.com/services/xxx' | base64)"

# Store AWS access key
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "aws-access-key" \
  --secret-content-content "$(echo -n '<your-aws-access-key>' | base64)"
```

### Secret Rotation Pattern
```bash
# 1. Get current secret value
CURRENT=$(oci secrets secret-bundle get \
  --secret-id $SECRET_ID \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d)

# 2. Generate new password/token (example)
NEW_PASSWORD=$(openssl rand -base64 32)

# 3. Update secret with new value
oci vault secret update-base64 \
  --secret-id $SECRET_ID \
  --secret-content-content "$(echo -n "$NEW_PASSWORD" | base64)"

# 4. Update application/database with new password
# ... application-specific logic ...

# 5. Verify new secret works
NEW=$(oci secrets secret-bundle get \
  --secret-id $SECRET_ID \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d)

echo "Password rotated successfully"
```

## Using Secrets in Applications

### Bash Script Example
```bash
#!/bin/bash
# retrieve-and-use-secret.sh

# Configuration
SECRET_ID="<your-secret-ocid>"

# Retrieve secret
SECRET_VALUE=$(oci secrets secret-bundle get \
  --secret-id "$SECRET_ID" \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d)

# Use secret (example: connect to database)
mysql -h hostname -u username -p"$SECRET_VALUE" dbname

# Clear variable
unset SECRET_VALUE
```

### Python Example
```python
import oci
import base64

# Initialize OCI client
secrets_client = oci.secrets.SecretsClient(
    oci.config.from_file()
)

# Retrieve secret
secret_id = "<your-secret-ocid>"
secret_bundle = secrets_client.get_secret_bundle(secret_id)

# Decode secret value
secret_content = secret_bundle.data.secret_bundle_content.content
decoded_secret = base64.b64decode(secret_content).decode('utf-8')

# Use secret
print(f"Retrieved secret: {decoded_secret}")
```

### Node.js Example
```javascript
const oci = require('oci-sdk');
const fs = require('fs');

// Load OCI config
const provider = new oci.common.ConfigFileAuthenticationDetailsProvider();
const client = new oci.secrets.SecretsClient({ authenticationDetailsProvider: provider });

async function getSecret(secretId) {
  const request = { secretId: secretId };
  const response = await client.getSecretBundle(request);

  // Decode base64 content
  const secretContent = response.secretBundle.secretBundleContent.content;
  const decodedSecret = Buffer.from(secretContent, 'base64').toString('utf-8');

  return decodedSecret;
}

// Usage
getSecret('ocid1.vaultsecret.oc1...').then(secret => {
  console.log('Retrieved secret:', secret);
});
```

## IAM Policies for Vault Access

### Allow Users to Manage Vaults
```
Allow group VaultAdmins to manage vaults in compartment SecurityCompartment
Allow group VaultAdmins to manage keys in compartment SecurityCompartment
Allow group VaultAdmins to manage secret-family in compartment SecurityCompartment
```

### Allow Applications to Read Secrets
```
Allow dynamic-group AppServers to read secret-bundles in compartment ProductionCompartment
Allow dynamic-group AppServers to read secrets in compartment ProductionCompartment
```

### Allow Service to Use Encryption Keys
```
Allow service blockstorage to use keys in compartment ProductionCompartment
Allow service objectstorage to use keys in compartment ProductionCompartment
Allow service database to use keys in compartment ProductionCompartment
```

## Best Practices

### Vault Organization
1. **Separate vaults**: Use different vaults for dev, test, prod environments
2. **Virtual private vaults**: Use for high-security requirements
3. **Compartment isolation**: Place vaults in dedicated security compartments
4. **Naming convention**: Use clear, consistent naming (env-purpose-vault)

### Key Management
1. **Key rotation**: Rotate keys regularly (annually or based on policy)
2. **Separate keys**: Use different keys for different purposes
3. **Key hierarchy**: Use master keys to encrypt data encryption keys (envelope encryption)
4. **Deletion grace period**: Use maximum 30-day deletion window for recovery
5. **Never export keys**: Keep keys within OCI HSM

### Secrets Management
1. **Least privilege**: Grant minimum required access to secrets
2. **Secret rotation**: Rotate secrets regularly (90 days recommended)
3. **Version control**: Keep multiple versions for rollback capability
4. **Metadata tagging**: Tag secrets with purpose, environment, owner
5. **Audit access**: Enable logging and monitor secret access

### Application Integration
1. **Cache sparingly**: Minimize secret caching in applications
2. **Environment variables**: Never hardcode secrets in code
3. **Dynamic retrieval**: Fetch secrets at runtime, not build time
4. **Error handling**: Handle secret retrieval failures gracefully
5. **Secure memory**: Clear secret values from memory after use

### Security
1. **IAM policies**: Use fine-grained policies for secret access
2. **Dynamic groups**: Use for compute instance secret access
3. **Audit logging**: Enable and review audit logs regularly
4. **Network security**: Use private endpoints for vault access
5. **Compliance**: Follow industry standards (PCI-DSS, HIPAA, etc.)

## Common Workflows

### Initial Vault Setup for New Project
1. Create dedicated compartment for security resources
2. Create vault in security compartment
3. Create master encryption key
4. Configure IAM policies for access control
5. Create secrets for application credentials
6. Test secret retrieval from application
7. Document secret names and usage

### Rotating Database Password
1. Generate new password
2. Create new secret version with new password
3. Update database with new password
4. Verify application can connect with new credentials
5. Wait grace period (24 hours)
6. Delete old secret version

### Migrating Secrets to OCI Vault
1. Identify all secrets currently in code/config files
2. Create vault and encryption key
3. Create secrets in vault
4. Update application to retrieve from vault
5. Test thoroughly in non-production
6. Deploy to production
7. Remove secrets from code/config files

## Troubleshooting

### Cannot Create Vault
- Verify compartment OCID is correct
- Check service limits for vaults in tenancy
- Ensure IAM permissions to create vaults
- Verify region supports Vault service

### Cannot Access Secret
- Check IAM policies grant read permission
- Verify secret is in ACTIVE state
- Confirm compartment OCID is correct
- For dynamic groups, verify instance is member

### Secret Retrieval Returns Error
- Check secret OCID is correct
- Verify secret version is not deleted
- Ensure encryption key is enabled
- Confirm vault is active

### Encryption Operation Fails
- Verify key is in ENABLED state
- Check key algorithm matches operation
- Ensure plaintext is base64 encoded
- Validate endpoint URL is correct

## Integration with Other OCI Services

### Compute Instances
- Use instance principals (dynamic groups) for secret access
- Store SSH keys, API tokens in vault
- Retrieve secrets in cloud-init scripts

### Functions
- Store function configuration secrets
- API keys for external services
- Database connection strings

### Kubernetes/OKE
- Use Kubernetes secrets provider for OCI Vault
- Store container registry credentials
- Application configuration secrets

### Database Services
- Customer-managed encryption keys for data encryption
- Store admin passwords securely
- Wallet passwords for ADB

## When to Use This Skill

Activate this skill when the user mentions:
- Storing sensitive information, credentials, or passwords
- Managing encryption keys or cryptographic operations
- Secrets management or secret rotation
- OCI Vault or Key Management Service (KMS)
- Encrypting or decrypting data
- Secure credential storage for applications
- API keys, tokens, or certificates
- BYOK (Bring Your Own Key)
- Master encryption keys or data encryption keys
- Secrets in environment variables or configuration

## Example Interactions

**User**: "Store my database password securely"
**Response**: Use this skill to create vault, encryption key, and secret with appropriate CLI commands.

**User**: "How do I rotate my API key?"
**Response**: Use this skill to show secret version creation and rotation workflow.

**User**: "My application needs to retrieve a secret"
**Response**: Use this skill to demonstrate secret retrieval with code examples in relevant language.

**User**: "What IAM policies do I need for secret access?"
**Response**: Use this skill to provide appropriate IAM policy statements for the use case.
