---
name: OCI IAM and Identity Management
description: Expert in Oracle Cloud Infrastructure Identity and Access Management (IAM), IDCS integration, policies, users, groups, dynamic groups, and authentication. Complete CLI reference.
version: 1.0.0
---

# OCI IAM and Identity Management Skill

You are an expert in Oracle Cloud Infrastructure Identity and Access Management (IAM) and Oracle Identity Cloud Service (IDCS) integration. This skill provides comprehensive CLI commands and best practices to compensate for Claude's limited OCI training data.

## Core IAM Concepts

### Principals
- **Users**: Individual people or applications
- **Groups**: Collections of users
- **Dynamic groups**: Groups based on instance/resource criteria
- **Service principals**: OCI services accessing resources

### Resources
- Compartments, instances, databases, buckets, etc.
- Resource types organized by service

### Policies
- Rules defining what principals can do with resources
- Written in policy language: `Allow <subject> to <verb> <resource> in <location> where <conditions>`

### Authentication
- API signing keys for API/CLI access
- Auth tokens for HTTP-based services
- Customer secret keys for S3-compatible access
- IDCS integration for SSO

## Compartment Management

### List and View Compartments
```bash
# List all compartments in tenancy
oci iam compartment list

# List compartments with specific parent
oci iam compartment list \
  --compartment-id <parent-compartment-ocid>

# Get compartment details
oci iam compartment get \
  --compartment-id <compartment-ocid>

# List all compartments recursively (including sub-compartments)
oci iam compartment list \
  --compartment-id-in-subtree true

# Get current user's tenancy information
oci iam tenancy get \
  --tenancy-id <tenancy-ocid>
```

### Create and Manage Compartments
```bash
# Create a compartment
oci iam compartment create \
  --compartment-id <parent-compartment-ocid> \
  --name "ProductionEnv" \
  --description "Production environment resources"

# Update compartment description
oci iam compartment update \
  --compartment-id <compartment-ocid> \
  --description "Updated description"

# Move compartment to different parent
oci iam compartment move \
  --compartment-id <compartment-ocid> \
  --target-compartment-id <new-parent-ocid>

# Delete compartment (must be empty)
oci iam compartment delete \
  --compartment-id <compartment-ocid>

# Recover deleted compartment (within 30 days)
oci iam compartment recover \
  --compartment-id <compartment-ocid>
```

### Compartment Best Practices
- **Hierarchy**: Design 3-4 level hierarchy (Tenancy → Business Unit → Environment → Application)
- **Naming**: Use clear, consistent naming conventions
- **Isolation**: Separate production, development, testing
- **Budgets**: Set budget alerts per compartment
- **Policies**: Apply policies at appropriate compartment level

## User Management

### List and View Users
```bash
# List all users in tenancy
oci iam user list \
  --compartment-id <tenancy-ocid>

# Get user details
oci iam user get \
  --user-id <user-ocid>

# Get current user
oci iam user get \
  --user-id $(oci iam user list --query 'data[0].id' --raw-output)

# List users in specific group
oci iam group list-users \
  --group-id <group-ocid>
```

### Create and Manage Users
```bash
# Create user
oci iam user create \
  --name "john.doe@example.com" \
  --description "John Doe - Developer" \
  --email "john.doe@example.com"

# Update user description
oci iam user update \
  --user-id <user-ocid> \
  --description "John Doe - Senior Developer"

# Delete user
oci iam user delete \
  --user-id <user-ocid>

# Create or reset user password (for console access)
oci iam user create-or-reset-ui-password \
  --user-id <user-ocid>
```

### User Credentials Management

#### API Keys
```bash
# List user's API keys
oci iam user api-key list \
  --user-id <user-ocid>

# Upload API key (for CLI/SDK access)
oci iam user api-key upload \
  --user-id <user-ocid> \
  --key-file ~/.oci/oci_api_key_public.pem

# Delete API key
oci iam user api-key delete \
  --user-id <user-ocid> \
  --fingerprint "<key-fingerprint>"
```

#### Auth Tokens
```bash
# List auth tokens
oci iam auth-token list \
  --user-id <user-ocid>

# Create auth token (for Docker, Swift, etc.)
oci iam auth-token create \
  --user-id <user-ocid> \
  --description "Docker registry access"

# Delete auth token
oci iam auth-token delete \
  --user-id <user-ocid> \
  --auth-token-id <token-ocid>
```

#### Customer Secret Keys (S3 compatibility)
```bash
# List customer secret keys
oci iam customer-secret-key list \
  --user-id <user-ocid>

# Create customer secret key
oci iam customer-secret-key create \
  --user-id <user-ocid> \
  --display-name "S3 access key"

# Delete customer secret key
oci iam customer-secret-key delete \
  --user-id <user-ocid> \
  --customer-secret-key-id <key-ocid>
```

## Group Management

### List and View Groups
```bash
# List all groups
oci iam group list \
  --compartment-id <tenancy-ocid>

# Get group details
oci iam group get \
  --group-id <group-ocid>

# List groups a user belongs to
oci iam user-group-membership list \
  --user-id <user-ocid> \
  --compartment-id <tenancy-ocid>
```

### Create and Manage Groups
```bash
# Create group
oci iam group create \
  --name "Developers" \
  --description "Development team members" \
  --compartment-id <tenancy-ocid>

# Update group
oci iam group update \
  --group-id <group-ocid> \
  --description "Updated description"

# Delete group
oci iam group delete \
  --group-id <group-ocid>
```

### Group Membership
```bash
# Add user to group
oci iam group add-user \
  --group-id <group-ocid> \
  --user-id <user-ocid>

# Remove user from group
oci iam group remove-user \
  --group-id <group-ocid> \
  --user-id <user-ocid>

# List all memberships for a user
oci iam user-group-membership list \
  --user-id <user-ocid> \
  --compartment-id <tenancy-ocid>
```

## Dynamic Groups

Dynamic groups automatically include compute instances and other resources based on matching rules.

### List and View Dynamic Groups
```bash
# List all dynamic groups
oci iam dynamic-group list \
  --compartment-id <tenancy-ocid>

# Get dynamic group details
oci iam dynamic-group get \
  --dynamic-group-id <dynamic-group-ocid>
```

### Create Dynamic Groups
```bash
# Create dynamic group for all instances in compartment
oci iam dynamic-group create \
  --name "ComputeInstances" \
  --description "All compute instances" \
  --matching-rule "ALL {instance.compartment.id = '<compartment-ocid>'}" \
  --compartment-id <tenancy-ocid>

# Dynamic group for specific instances
oci iam dynamic-group create \
  --name "WebServers" \
  --description "Web server instances" \
  --matching-rule "ANY {instance.id = '<instance-1-ocid>', instance.id = '<instance-2-ocid>'}" \
  --compartment-id <tenancy-ocid>

# Dynamic group with multiple conditions
oci iam dynamic-group create \
  --name "ProdInstances" \
  --description "Production instances with tag" \
  --matching-rule "ALL {instance.compartment.id = '<compartment-ocid>', tag.environment.value = 'production'}" \
  --compartment-id <tenancy-ocid>

# Dynamic group for Autonomous Database instances
oci iam dynamic-group create \
  --name "AutonomousDatabases" \
  --description "All ADB instances" \
  --matching-rule "ALL {resource.type = 'autonomousdatabase'}" \
  --compartment-id <tenancy-ocid>
```

### Common Matching Rules

**All instances in compartment:**
```
ALL {instance.compartment.id = '<compartment-ocid>'}
```

**Specific instance:**
```
instance.id = '<instance-ocid>'
```

**Multiple instances:**
```
ANY {instance.id = '<instance-1>', instance.id = '<instance-2>'}
```

**Instances with specific tag:**
```
ALL {instance.compartment.id = '<compartment-ocid>', tag.key.value = 'value'}
```

**All Functions in compartment:**
```
ALL {resource.type = 'fnfunc', resource.compartment.id = '<compartment-ocid>'}
```

**All Autonomous Databases:**
```
resource.type = 'autonomousdatabase'
```

### Update Dynamic Groups
```bash
# Update matching rules
oci iam dynamic-group update \
  --dynamic-group-id <dynamic-group-ocid> \
  --matching-rule "ALL {instance.compartment.id = '<new-compartment-ocid>'}"

# Delete dynamic group
oci iam dynamic-group delete \
  --dynamic-group-id <dynamic-group-ocid>
```

## Policy Management

### List and View Policies
```bash
# List policies in compartment
oci iam policy list \
  --compartment-id <compartment-ocid>

# Get policy details
oci iam policy get \
  --policy-id <policy-ocid>

# List policies in tenancy (root)
oci iam policy list \
  --compartment-id <tenancy-ocid>
```

### Create Policies
```bash
# Create basic policy
oci iam policy create \
  --compartment-id <compartment-ocid> \
  --name "DevelopersPolicy" \
  --description "Allow developers to manage compute" \
  --statements '["Allow group Developers to manage instance-family in compartment Development"]'

# Create policy with multiple statements
oci iam policy create \
  --compartment-id <tenancy-ocid> \
  --name "NetworkAdminsPolicy" \
  --description "Network administrators policy" \
  --statements '[
    "Allow group NetworkAdmins to manage virtual-network-family in tenancy",
    "Allow group NetworkAdmins to manage load-balancers in tenancy",
    "Allow group NetworkAdmins to manage dns in tenancy"
  ]'

# Create policy for dynamic group (instance principals)
oci iam policy create \
  --compartment-id <tenancy-ocid> \
  --name "InstanceAccessPolicy" \
  --description "Allow instances to access object storage" \
  --statements '["Allow dynamic-group ComputeInstances to read objects in compartment Production"]'
```

### Common Policy Patterns

#### Full Access Policies
```
// Tenancy administrators
Allow group Administrators to manage all-resources in tenancy

// Compartment administrators
Allow group CompartmentAdmins to manage all-resources in compartment ProjectA
```

#### Compute Policies
```
// Manage compute instances
Allow group Developers to manage instance-family in compartment Development

// Launch instances only
Allow group Developers to use instance-family in compartment Development
Allow group Developers to use volume-family in compartment Development
Allow group Developers to use virtual-network-family in compartment Development

// Read-only compute access
Allow group Auditors to inspect instance-family in compartment Production
```

#### Networking Policies
```
// Manage VCNs and subnets
Allow group NetworkTeam to manage virtual-network-family in compartment Production

// Manage security lists and NSGs
Allow group SecurityTeam to manage network-security-groups in compartment Production
Allow group SecurityTeam to manage security-lists in compartment Production
```

#### Database Policies
```
// Manage Autonomous Databases
Allow group DBAdmins to manage autonomous-database-family in compartment Production

// Manage DB Systems
Allow group DBAdmins to manage database-family in compartment Production
Allow group DBAdmins to manage db-systems in compartment Production

// Read database metrics
Allow group DBAdmins to read metrics in compartment Production
```

#### Object Storage Policies
```
// Full object storage access
Allow group DataTeam to manage object-family in compartment DataLake

// Read-only access
Allow group Analysts to read objects in compartment DataLake

// Write-only (for backups)
Allow group BackupSystem to manage objects in compartment Backups where request.permission='OBJECT_CREATE'
```

#### Secrets and Vault Policies
```
// Manage secrets
Allow group SecurityTeam to manage secret-family in compartment Security
Allow group SecurityTeam to manage vaults in compartment Security

// Read secrets (for applications)
Allow dynamic-group AppServers to read secret-bundles in compartment Production
Allow dynamic-group AppServers to read secrets in compartment Production

// Use encryption keys
Allow group DBAdmins to use keys in compartment Security
```

#### Monitoring and Logging Policies
```
// View metrics and alarms
Allow group Operations to read metrics in compartment Production
Allow group Operations to manage alarms in compartment Production

// Manage logs
Allow group Operations to manage log-groups in compartment Production
Allow group Operations to manage logs in compartment Production
Allow group Operations to read log-content in compartment Production
```

#### Dynamic Group Policies (Instance Principals)
```
// Allow instances to read from Object Storage
Allow dynamic-group ComputeInstances to read objects in compartment Production

// Allow instances to access secrets
Allow dynamic-group AppServers to read secret-bundles in compartment Production
Allow dynamic-group AppServers to use keys in compartment Security

// Allow Functions to access resources
Allow dynamic-group ServerlessFunctions to manage all-resources in compartment Functions
```

### Policy Conditions

Policies can include WHERE clauses for fine-grained control:

```
// Allow only specific object actions
Allow group Developers to manage objects in compartment Dev where request.permission='OBJECT_CREATE'

// Allow only during business hours
Allow group Contractors to use instance-family in compartment Dev where request.time.hours >= 8 && request.time.hours <= 18

// Restrict by region
Allow group USTeam to manage instance-family in compartment Production where target.region='us-phoenix-1'

// Restrict by IP address
Allow group RemoteWorkers to use instance-family in compartment Dev where request.networkSource.name='CorporateVPN'
```

### Update and Delete Policies
```bash
# Update policy statements
oci iam policy update \
  --policy-id <policy-ocid> \
  --statements '["Allow group Developers to manage instance-family in compartment Development"]'

# Update policy description
oci iam policy update \
  --policy-id <policy-ocid> \
  --description "Updated policy description"

# Delete policy
oci iam policy delete \
  --policy-id <policy-ocid>
```

## IDCS Integration

### Authentication Settings
```bash
# List identity providers
oci iam identity-provider list \
  --protocol SAML2 \
  --compartment-id <tenancy-ocid>

# Get identity provider details
oci iam identity-provider get \
  --identity-provider-id <idp-ocid>
```

### Federation Setup
```bash
# Create SAML2 identity provider
oci iam identity-provider create-saml2-identity-provider \
  --compartment-id <tenancy-ocid> \
  --name "CorporateIDP" \
  --description "Corporate SAML identity provider" \
  --metadata-file file://idp-metadata.xml \
  --product-type IDCS

# Update identity provider
oci iam identity-provider update-saml2-identity-provider \
  --identity-provider-id <idp-ocid> \
  --description "Updated description"

# Delete identity provider
oci iam identity-provider delete \
  --identity-provider-id <idp-ocid>
```

### Identity Provider Group Mapping
```bash
# Create IdP group mapping
oci iam idp-group-mapping create \
  --identity-provider-id <idp-ocid> \
  --idp-group-name "IDCS-Developers" \
  --group-id <oci-group-ocid>

# List IdP group mappings
oci iam idp-group-mapping list \
  --identity-provider-id <idp-ocid>

# Delete IdP group mapping
oci iam idp-group-mapping delete \
  --identity-provider-id <idp-ocid> \
  --mapping-id <mapping-ocid>
```

## Network Sources (IP-based Access Control)

```bash
# List network sources
oci iam network-sources list \
  --compartment-id <tenancy-ocid>

# Create network source
oci iam network-sources create \
  --compartment-id <tenancy-ocid> \
  --name "CorporateVPN" \
  --description "Corporate VPN IP ranges" \
  --public-source-list '["203.0.113.0/24", "198.51.100.0/24"]'

# Update network source
oci iam network-sources update \
  --network-source-id <source-ocid> \
  --public-source-list '["203.0.113.0/24"]'

# Delete network source
oci iam network-sources delete \
  --network-source-id <source-ocid>
```

## Tags and Tag Namespaces

### Tag Namespaces
```bash
# List tag namespaces
oci iam tag-namespace list \
  --compartment-id <compartment-ocid>

# Create tag namespace
oci iam tag-namespace create \
  --compartment-id <compartment-ocid> \
  --name "Operations" \
  --description "Operations-related tags"

# Get tag namespace
oci iam tag-namespace get \
  --tag-namespace-id <namespace-ocid>
```

### Tag Keys
```bash
# Create tag key
oci iam tag create \
  --tag-namespace-id <namespace-ocid> \
  --name "Environment" \
  --description "Environment type"

# Create tag with validator (allowed values)
oci iam tag create \
  --tag-namespace-id <namespace-ocid> \
  --name "Environment" \
  --description "Environment type" \
  --validator '{"validatorType":"ENUM","values":["Dev","Test","Prod"]}'

# List tags in namespace
oci iam tag list \
  --tag-namespace-id <namespace-ocid>

# Retire tag (prevent new usage)
oci iam tag update \
  --tag-name "Environment" \
  --tag-namespace-id <namespace-ocid> \
  --is-retired true
```

### Applying Tags to Resources
```bash
# Tag a compute instance
oci compute instance update \
  --instance-id <instance-ocid> \
  --defined-tags '{"Operations":{"Environment":"Prod","Owner":"TeamA"}}'

# Tag with freeform tags
oci compute instance update \
  --instance-id <instance-ocid> \
  --freeform-tags '{"CostCenter":"12345","Project":"WebApp"}'
```

## Best Practices

### IAM Organization
1. **Principle of least privilege**: Grant minimum required permissions
2. **Group-based access**: Assign permissions to groups, not individual users
3. **Compartment hierarchy**: Design logical hierarchy matching organization
4. **Dynamic groups**: Use for service-to-service access (instance principals)
5. **Regular audits**: Review policies and access quarterly

### Policy Design
1. **Specific over general**: Use specific verbs (inspect, read, use, manage)
2. **Compartment level**: Apply policies at appropriate compartment level
3. **Conditions**: Use WHERE clauses to further restrict access
4. **Documentation**: Document purpose of each policy
5. **Testing**: Test policies in non-production first

### Security
1. **MFA**: Enforce multi-factor authentication for administrators
2. **API key rotation**: Rotate API keys regularly (90-180 days)
3. **Password policy**: Enforce strong password requirements
4. **Session timeout**: Configure appropriate timeout values
5. **Federated identity**: Use IDCS/SAML for enterprise SSO

### Access Management
1. **Onboarding process**: Standardize user creation and group assignment
2. **Offboarding**: Promptly remove access for departing users
3. **Access reviews**: Quarterly review of user group memberships
4. **Break-glass accounts**: Maintain emergency access procedures
5. **Service accounts**: Use dedicated accounts for automation

## Troubleshooting

### Access Denied Errors
1. Check user is in correct group
2. Verify group has required policy statements
3. Confirm policy is in correct compartment
4. Check for policy conditions (WHERE clauses)
5. Verify resource is in expected compartment

### Authentication Issues
1. Verify API key fingerprint matches
2. Check config file format (~/.oci/config)
3. Confirm user has API key uploaded
4. Validate key file permissions (private key 600)
5. Check auth token hasn't expired

### Policy Not Working
1. Verify policy syntax is correct
2. Check policy is in parent compartment of resources
3. Confirm subject (group/dynamic-group) exists
4. Validate resource type names
5. Test with simpler policy first

### Dynamic Group Not Matching
1. Verify matching rule syntax
2. Check instance/resource OCID is correct
3. Confirm resource tags if using in rule
4. Test with broader matching rule
5. Verify resource is in expected compartment

## When to Use This Skill

Activate this skill when the user mentions:
- IAM, identity, access management, or permissions
- Users, groups, policies, or dynamic groups
- IDCS integration or federation
- Authentication, authorization, or access control
- Compartments or tenancy organization
- API keys, auth tokens, or credentials
- "Access denied" or permission errors
- Instance principals or service-to-service access
- Policy creation or troubleshooting
- SSO, SAML, or federated authentication
- Tags, tag namespaces, or resource organization

## Example Interactions

**User**: "Create a policy to allow developers to manage compute instances"
**Response**: Use this skill to provide appropriate policy statement with proper syntax and compartment scope.

**User**: "How do I give my compute instance access to Object Storage?"
**Response**: Use this skill to explain dynamic groups and instance principal policies.

**User**: "I'm getting access denied when trying to create a VCN"
**Response**: Use this skill to troubleshoot IAM policies and verify group memberships.

**User**: "Set up SSO with our corporate identity provider"
**Response**: Use this skill to guide through IDCS federation setup and group mapping.
