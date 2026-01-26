---
name: OCI Database Management
description: Manage Oracle Cloud Infrastructure database systems including Autonomous Databases, DB Systems, Exadata, and PDBs. Comprehensive CLI command reference with examples.
version: 1.0.0
---

# OCI Database Management Skill

You are an expert in Oracle Cloud Infrastructure database services. This skill provides comprehensive OCI CLI command references for all database operations to compensate for Claude's limited OCI training data.

## Core Database Services

### Autonomous Database (ADB)
- Serverless and dedicated deployment options
- ATP (Transaction Processing) and ADW (Data Warehouse) workloads
- Automatic backups, patching, and tuning

### DB Systems
- Oracle Database on VM or bare metal
- RAC (Real Application Clusters) support
- Full control over database configuration

### Exadata Cloud Service
- Exadata infrastructure (Cloud@Customer and Cloud Service)
- High-performance database workloads
- Extreme scalability and availability

### Pluggable Databases (PDBs)
- Multi-tenant architecture within Container Database (CDB)
- Isolated database environments
- Clone, relocate, and manage PDBs

## Autonomous Database CLI Commands

### Listing and Viewing ADB
```bash
# List all Autonomous Databases in compartment
oci db autonomous-database list \
  --compartment-id <compartment-ocid>

# List only ATP databases
oci db autonomous-database list \
  --compartment-id <compartment-ocid> \
  --db-workload OLTP

# List only ADW databases
oci db autonomous-database list \
  --compartment-id <compartment-ocid> \
  --db-workload DW

# List by lifecycle state
oci db autonomous-database list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state AVAILABLE

# Get specific ADB details
oci db autonomous-database get \
  --autonomous-database-id <adb-ocid>

# Get connection strings
oci db autonomous-database get \
  --autonomous-database-id <adb-ocid> \
  --query 'data."connection-strings"'
```

### Creating Autonomous Database
```bash
# Create ATP database (always-free tier)
oci db autonomous-database create \
  --compartment-id <compartment-ocid> \
  --db-name "myatpdb" \
  --display-name "My ATP Database" \
  --admin-password "SecurePass123!" \
  --cpu-core-count 1 \
  --data-storage-size-in-tbs 1 \
  --db-workload OLTP \
  --is-free-tier true

# Create ATP database (paid tier with more resources)
oci db autonomous-database create \
  --compartment-id <compartment-ocid> \
  --db-name "prodatp" \
  --display-name "Production ATP" \
  --admin-password "SecurePass123!" \
  --cpu-core-count 2 \
  --data-storage-size-in-tbs 1 \
  --db-workload OLTP \
  --is-auto-scaling-enabled true \
  --license-model LICENSE_INCLUDED

# Create ADW database
oci db autonomous-database create \
  --compartment-id <compartment-ocid> \
  --db-name "myadw" \
  --display-name "My Data Warehouse" \
  --admin-password "SecurePass123!" \
  --cpu-core-count 2 \
  --data-storage-size-in-tbs 1 \
  --db-workload DW \
  --is-auto-scaling-enabled true

# Create with private endpoint
oci db autonomous-database create \
  --compartment-id <compartment-ocid> \
  --db-name "privatedb" \
  --display-name "Private ATP" \
  --admin-password "SecurePass123!" \
  --cpu-core-count 1 \
  --data-storage-size-in-tbs 1 \
  --db-workload OLTP \
  --subnet-id <subnet-ocid> \
  --nsg-ids '["<nsg-ocid>"]'
```

### Updating Autonomous Database
```bash
# Scale up CPU cores
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --cpu-core-count 4

# Scale up storage
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --data-storage-size-in-tbs 2

# Enable auto-scaling
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --is-auto-scaling-enabled true

# Update display name
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --display-name "New Database Name"

# Change license type
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --license-model BRING_YOUR_OWN_LICENSE

# Update admin password
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --admin-password "NewSecurePass123!"
```

### ADB Lifecycle Operations
```bash
# Stop database (to save costs)
oci db autonomous-database stop \
  --autonomous-database-id <adb-ocid>

# Start database
oci db autonomous-database start \
  --autonomous-database-id <adb-ocid>

# Delete database (requires --force for immediate deletion)
oci db autonomous-database delete \
  --autonomous-database-id <adb-ocid> \
  --force
```

### ADB Wallet Management
```bash
# Download wallet for database connection
oci db autonomous-database generate-wallet \
  --autonomous-database-id <adb-ocid> \
  --password "WalletPass123!" \
  --file wallet.zip

# Get regional wallet (works for all ADBs in region)
oci db autonomous-database-regional-wallet get \
  --file regional-wallet.zip \
  --password "WalletPass123!"
```

### ADB Backup and Clone
```bash
# List backups
oci db autonomous-database-backup list \
  --autonomous-database-id <adb-ocid>

# Get backup details
oci db autonomous-database-backup get \
  --autonomous-database-backup-id <backup-ocid>

# Create manual backup
oci db autonomous-database-backup create \
  --autonomous-database-id <adb-ocid> \
  --display-name "Manual Backup"

# Create clone from source database
oci db autonomous-database create-from-clone-adb \
  --compartment-id <compartment-ocid> \
  --source-id <source-adb-ocid> \
  --clone-type FULL \
  --db-name "cloneddb" \
  --display-name "Cloned Database"

# Create refreshable clone
oci db autonomous-database create-refreshable-clone \
  --compartment-id <compartment-ocid> \
  --source-id <source-adb-ocid> \
  --db-name "refclone" \
  --display-name "Refreshable Clone"
```

## DB Systems CLI Commands

### Listing DB Systems
```bash
# List all DB systems
oci db system list \
  --compartment-id <compartment-ocid>

# List by availability domain
oci db system list \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name>

# Get DB system details
oci db system get \
  --db-system-id <db-system-ocid>

# List DB homes in system
oci db db-home list \
  --compartment-id <compartment-ocid> \
  --db-system-id <db-system-ocid>

# List databases in DB home
oci db database list \
  --compartment-id <compartment-ocid> \
  --db-home-id <db-home-ocid>
```

### Creating DB Systems
```bash
# Launch VM DB system
oci db system launch \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name> \
  --subnet-id <subnet-ocid> \
  --shape "VM.Standard2.1" \
  --ssh-authorized-keys-file ~/.ssh/id_rsa.pub \
  --hostname "dbhost" \
  --db-name "mydb" \
  --admin-password "SecurePass123!" \
  --db-version "19.0.0.0" \
  --database-edition "ENTERPRISE_EDITION" \
  --cpu-core-count 2 \
  --storage-management "LVM" \
  --node-count 1

# Launch RAC DB system (2 nodes)
oci db system launch \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name> \
  --subnet-id <subnet-ocid> \
  --backup-subnet-id <backup-subnet-ocid> \
  --shape "VM.Standard2.2" \
  --ssh-authorized-keys-file ~/.ssh/id_rsa.pub \
  --hostname "racdb" \
  --db-name "racdb" \
  --admin-password "SecurePass123!" \
  --db-version "19.0.0.0" \
  --database-edition "ENTERPRISE_EDITION_EXTREME_PERFORMANCE" \
  --cpu-core-count 4 \
  --node-count 2 \
  --cluster-name "racluster"
```

### DB System Operations
```bash
# Update DB system (scale CPU)
oci db system update \
  --db-system-id <db-system-ocid> \
  --cpu-core-count 4

# Patch DB system
# First, list available patches
oci db patch list by-db-system \
  --db-system-id <db-system-ocid>

# Apply patch
oci db system patch \
  --db-system-id <db-system-ocid> \
  --patch-id <patch-ocid> \
  --patch-action APPLY

# Terminate DB system
oci db system terminate \
  --db-system-id <db-system-ocid>
```

### Database Operations within DB System
```bash
# Get database details
oci db database get \
  --database-id <database-ocid>

# Update database
oci db database update \
  --database-id <database-ocid> \
  --db-backup-config file://backup-config.json

# Delete database
oci db database delete \
  --database-id <database-ocid>

# List database backups
oci db backup list \
  --database-id <database-ocid>

# Create backup
oci db backup create \
  --database-id <database-ocid> \
  --display-name "Manual Backup"

# Restore database from backup
oci db database restore \
  --database-id <database-ocid> \
  --backup-id <backup-ocid>
```

## Pluggable Database (PDB) CLI Commands

### Managing PDBs
```bash
# List all PDBs
oci db pluggable-database list \
  --compartment-id <compartment-ocid>

# Get PDB details
oci db pluggable-database get \
  --pluggable-database-id <pdb-ocid>

# Create PDB in CDB
oci db pluggable-database create \
  --compartment-id <compartment-ocid> \
  --container-database-id <cdb-ocid> \
  --pdb-name "PDB1" \
  --pdb-admin-password "PdbPass123!"

# Create PDB from local clone
oci db pluggable-database create-pluggable-database-from-local-clone \
  --compartment-id <compartment-ocid> \
  --pdb-name "PDB_CLONE" \
  --container-database-id <cdb-ocid> \
  --source-pluggable-database-id <source-pdb-ocid> \
  --pdb-admin-password "PdbPass123!"

# Update PDB
oci db pluggable-database update \
  --pluggable-database-id <pdb-ocid> \
  --pdb-admin-password "NewPdbPass123!"

# Delete PDB
oci db pluggable-database delete \
  --pluggable-database-id <pdb-ocid>
```

## Database Versions and Shapes

### Available Database Versions
```bash
# List database versions for DB systems
oci db version list \
  --compartment-id <compartment-ocid>

# List database versions for specific shape
oci db version list \
  --compartment-id <compartment-ocid> \
  --db-system-shape "VM.Standard2.1"

# List Autonomous Database versions
oci db autonomous-db-version list \
  --compartment-id <compartment-ocid>
```

### Database Shapes
```bash
# List DB system shapes
oci db system-shape list \
  --compartment-id <compartment-ocid>

# List shapes for specific availability domain
oci db system-shape list \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name>
```

## Best Practices

### Autonomous Database
1. **Start with Always Free**: Test workloads with always-free tier before scaling
2. **Enable auto-scaling**: Let ADB automatically scale for workload spikes
3. **Use private endpoints**: Keep databases off public internet when possible
4. **Download wallets securely**: Protect wallet files, they contain connection credentials
5. **Monitor CPU utilization**: Watch for sustained high usage indicating need to scale
6. **Regular backups**: While automatic, test restore procedures periodically

### DB Systems
1. **Choose appropriate shape**: Match shape to workload (VM for dev/test, bare metal for production)
2. **Use separate subnets**: Put database in private subnet, use bastion for access
3. **Enable automatic backups**: Configure retention period based on requirements
4. **Plan for patching**: Schedule maintenance windows for patches
5. **RAC for HA**: Use 2+ node RAC for high availability requirements
6. **Backup strategy**: Test backup and restore procedures

### Security
1. **Strong passwords**: Use complex passwords for admin accounts (min 12 chars, mixed case, numbers, symbols)
2. **Network security**: Use NSGs to restrict database access to specific sources
3. **Encryption**: Data is encrypted at rest by default, ensure TLS for connections
4. **Audit configuration**: Enable database auditing for compliance requirements
5. **Regular updates**: Apply security patches promptly

### Cost Optimization
1. **Stop when idle**: Stop Autonomous Databases during non-business hours (dev/test)
2. **Right-size**: Start small and scale up based on actual usage metrics
3. **Choose license model**: BYOL if you have existing licenses, otherwise use license-included
4. **Monitor storage**: Regular cleanup of unused data and logs
5. **Auto-scaling boundaries**: Set appropriate auto-scaling limits to control costs

## Common Workflows

### Setting Up Development Database
1. Create always-free tier ATP database
2. Download wallet file
3. Test connection using SQL*Plus or SQL Developer
4. Create schema and load sample data
5. Configure backup retention (automatic)
6. Stop database when not in use to save costs

### Migrating On-Premises Database to OCI
1. Assess source database (version, size, features)
2. Choose target service (ADB for simplicity, DB System for full control)
3. Create target database with appropriate resources
4. Use Data Pump, RMAN, or Golden Gate for migration
5. Test application connectivity and performance
6. Cutover to OCI database

### Creating Database Clone for Testing
1. Identify source database (production)
2. Create refreshable or full clone
3. Update connection strings in test environment
4. Mask sensitive data if needed
5. Grant access to test team
6. Refresh clone periodically from production

## Error Handling and Troubleshooting

### Common Errors

**"Service limit exceeded"**
- Check compartment/tenancy limits for database type
- Request limit increase through support portal
- Use different region with available capacity

**"Insufficient capacity"**
- Try different availability domain
- Use alternative shape
- Contact Oracle support for capacity

**"Invalid password"**
- Ensure password meets complexity requirements:
  - 12-30 characters
  - 2 uppercase, 2 lowercase, 2 numbers, 2 special chars
  - No username in password

**"Wallet generation failed"**
- Verify database is in AVAILABLE state
- Check IAM permissions for wallet generation
- Ensure password meets requirements

**"Connection refused"**
- Verify wallet is correctly configured
- Check network security rules (NSG, security list)
- Confirm TNS_ADMIN points to wallet location
- Validate database is running (not stopped)

### Troubleshooting Steps

For connection issues:
1. Verify database lifecycle state (should be AVAILABLE)
2. Check network security rules allow traffic from source
3. Validate wallet/credentials are correct
4. Test with SQL*Plus or other CLI tools first
5. Review database alerts and logs

For performance issues:
1. Check CPU and storage metrics in OCI Console
2. Review AWR reports for bottlenecks
3. Analyze slow queries and execution plans
4. Consider scaling up resources
5. Enable auto-scaling if not already enabled

## Integration with Other Skills

- **Compute**: Database connections from compute instances
- **Networking**: VCN, subnet, and security group configuration for database access
- **Monitoring**: Track database performance metrics and set up alarms
- **Storage**: Backup storage management and retention policies

## When to Use This Skill

Activate this skill when the user mentions:
- Creating, updating, or managing databases
- Autonomous Database, ATP, ADW, or serverless database
- DB Systems, RAC, Exadata, or database infrastructure
- Pluggable databases (PDB) or container databases (CDB)
- Database backups, cloning, or disaster recovery
- Database connectivity issues or wallet files
- Database versions, shapes, or capacity planning
- Database security, encryption, or access control
- SQL*Net configuration or TNS names
- Database performance tuning or scaling

## Example Interactions

**User**: "Create an Autonomous Database for development"
**Response**: Use this skill to execute the appropriate `oci db autonomous-database create` command with always-free tier options.

**User**: "How do I connect to my ATP database?"
**Response**: Use this skill to guide through wallet download, wallet configuration, and connection string usage.

**User**: "I need to scale up my database for a load test"
**Response**: Use this skill to show CPU and storage scaling commands with appropriate `oci db autonomous-database update` syntax.

**User**: "Clone my production database to test environment"
**Response**: Use this skill to demonstrate clone creation with proper commands and best practices for test data handling.
