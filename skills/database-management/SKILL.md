---
name: OCI Database Management
description: Use when creating Autonomous Databases, troubleshooting connection failures, managing PDBs, or optimizing database costs. Covers connection string confusion, password validation errors, stop/start cost traps, clone type selection, and backup retention gotchas. Keywords: wallet connection refused, service name HIGH MEDIUM LOW, password complexity, clone vs refreshable, storage charges when stopped.
version: 2.0.0
---

# OCI Database Management - Expert Knowledge

You are an OCI Database expert. This skill provides knowledge Claude lacks: connection string gotchas, cost traps, backup/clone patterns, PDB management mistakes, and ADB-specific operational knowledge.

## NEVER Do This

❌ **NEVER use wrong connection service name (performance/cost impact)**
```
Autonomous Database provides 3 service names:
- HIGH: Dedicated CPU, highest performance, **3x cost of LOW**
- MEDIUM: Shared CPU, balanced
- LOW: Most sharing, cheapest, sufficient for OLTP

# WRONG - using HIGH for background jobs (expensive)
connection_string = adb_connection_strings["high"]  # 3x cost!

# RIGHT - match service to workload
connection_string = adb_connection_strings["low"]  # Batch jobs, reporting
connection_string = adb_connection_strings["high"]  # Critical transactions only
```

**Cost impact**: Using HIGH vs LOW for 24/7 connection pool: $220/month vs $73/month wasted (3x)

❌ **NEVER assume stopped database = zero cost**
```
# WRONG assumption - "stopped" database is free
Stop ADB at night to save costs

# Reality:
Stopped ADB charges:
- Storage: $0.025/GB/month continues
- Backups: Retention charges continue
- Compute: ZERO (only part that stops)

Example: 1TB ADB stopped 16 hrs/day
- Compute savings: $584/month × 67% = $391 saved
- Storage cost: $25.60/month (still charged)
- Net savings: $391/month (not $610 expected)
```

❌ **NEVER ignore password complexity (ALWAYS fails)**
```
OCI Database password requirements (strict regex):
- 12-30 characters
- 2+ uppercase, 2+ lowercase
- 2+ numbers, 2+ special (#-_)
- NO username in password
- NO repeating chars (aaa, 111)

# WRONG - fails validation
--admin-password "MyPass123"  # Only 1 special char, < 12 chars

# RIGHT - meets requirements
--admin-password "MyP@ssw0rd#2024"  # 2 upper, 2 lower, 2 num, 2 special, 16 chars
```

❌ **NEVER confuse clone types (performance/cost consequences)**
```
| Clone Type | Use Case | Cost | Refresh | When Source Deleted |
|------------|----------|------|---------|---------------------|
| **Full clone** | Prod → Dev (one-time) | Full ADB cost | Cannot refresh | Clone survives |
| **Refreshable clone** | Prod → Test (weekly refresh) | Storage only (~30%) | Manual refresh | Clone deleted |
| **Metadata clone** | Schema-only copy | Minimal | N/A | Clone survives |

# WRONG - full clone for dev environment that needs weekly prod data
oci db autonomous-database create-from-clone-adb \
  --clone-type FULL  # Wastes $500/month, no refresh capability

# RIGHT - refreshable clone for test environments
oci db autonomous-database create-refreshable-clone \
  # Costs $150/month storage, can refresh from prod weekly
```

**Cost trap**: Full clone for testing = $500/month vs $150/month for refreshable clone (70% savings)

❌ **NEVER delete CDB without checking PDBs first**
```
# WRONG - deletes Container Database with PDBs inside (data loss)
oci db database delete --database-id <cdb-ocid>
# All pluggable databases deleted with no warning!

# RIGHT - check for PDBs first
oci db pluggable-database list --container-database-id <cdb-ocid>
# If PDBs exist, decide: unplug, clone, or explicitly delete each
```

❌ **NEVER use ADMIN user in application code (security risk)**
```
# WRONG - application uses ADMIN credentials
app_config = {
    'user': 'ADMIN',
    'password': admin_password  # Full database control!
}

# RIGHT - create app-specific user with least privilege
CREATE USER app_user IDENTIFIED BY <password>;
GRANT CONNECT, RESOURCE TO app_user;
GRANT SELECT, INSERT, UPDATE ON app_schema.* TO app_user;
# ADMIN only for DBA tasks, never in application code
```

❌ **NEVER forget Always-Free limits (scale-up fails)**
```
Always-Free Autonomous Database limits:
- 1 OCPU max (cannot scale beyond)
- 20 GB storage max
- 1 database per tenancy per region
- NO private endpoints
- NO auto-scaling

# WRONG - trying to scale always-free database
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --cpu-core-count 2  # FAILS: Always-free max is 1 OCPU

# RIGHT - convert to paid tier first, THEN scale
oci db autonomous-database update \
  --autonomous-database-id <adb-ocid> \
  --is-free-tier false  # Convert to paid
# Now can scale to 2+ OCPUs
```

## Connection String Gotchas

### Wallet Connection Failure Decision Tree

```
"Connection refused" or "Wallet error"?
│
├─ Wallet file issues?
│  ├─ Check: TNS_ADMIN env variable set?
│  │  └─ export TNS_ADMIN=/path/to/wallet
│  ├─ Check: sqlnet.ora has correct wallet location?
│  │  └─ WALLET_LOCATION = (SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY="/path/to/wallet")))
│  └─ Check: Wallet password correct?
│
├─ Network security?
│  ├─ Private endpoint ADB?
│  │  └─ Check: Source IP in NSG/security list?
│  │  └─ Check: VPN/FastConnect for on-premises access?
│  └─ Public endpoint ADB?
│     └─ Check: Database whitelisted your IP? (Access Control List)
│
├─ Database state?
│  └─ Check: Lifecycle state = AVAILABLE (not STOPPED, UPDATING)?
│     └─ oci db autonomous-database get --autonomous-database-id <ocid> --query 'data."lifecycle-state"'
│
└─ Service name wrong?
   └─ Check: Using correct service name from tnsnames.ora?
      └─ HIGH: <dbname>_high
      └─ MEDIUM: <dbname>_medium
      └─ LOW: <dbname>_low
```

### Service Name Selection (Cost vs Performance)

| Service | CPU Allocation | Concurrency | Cost | Use For |
|---------|---------------|-------------|------|---------|
| **HIGH** | Dedicated OCPU | 1× OCPU count | 3× base | OLTP critical transactions, interactive queries |
| **MEDIUM** | Shared OCPU | 2× OCPU count | 1× base | Batch jobs, reporting, most apps |
| **LOW** | Most sharing | 3× OCPU count | 1× base | Background tasks, data loads |

**Example**: 2 OCPU ADB
- HIGH: 2 concurrent queries max, $584/month
- MEDIUM: 4 concurrent queries, $584/month
- LOW: 6 concurrent queries, $584/month (same cost, more concurrency)

**Gotcha**: HIGH doesn't cost more in ADB pricing, but uses more OCPU-hours if you scale based on load.

## Cost Optimization with Exact Calculations

### Stop vs Scale Down Decision

**Scenario**: Development ADB, 2 OCPUs, 1 TB storage, used 8 hrs/day weekdays only

**Option 1: Stop when not in use** (16 hrs/day + weekends)
```
Usage: 8 hrs/day × 5 days = 40 hrs/week (24% utilization)
Compute cost: $0.36/OCPU-hr × 2 × 40 × 4.3 weeks = $124/month
Storage cost: $0.025/GB/month × 1000 = $25/month
Total: $149/month
```

**Option 2: Scale to 1 OCPU always-on**
```
Compute cost: $0.36/OCPU-hr × 1 × 730 hrs = $263/month
Storage cost: $25/month
Total: $288/month
```

**Winner**: Stop/start saves $139/month (48% savings)

### License Model Impact

| Model | Cost | Use When |
|-------|------|----------|
| **License Included** | $0.36/OCPU-hr | No existing licenses |
| **BYOL** | $0.18/OCPU-hr | Have Oracle DB licenses (50% off) |

**Scenario**: 4 OCPU ADB, 24/7 production
- License Included: $0.36 × 4 × 730 = $1,051/month
- BYOL: $0.18 × 4 × 730 = $526/month
- **Savings**: $525/month ($6,300/year) if you have licenses

**Gotcha**: BYOL requires proof of licenses if audited

### Auto-Scaling Cost Control

```hcl
# DANGER - unbounded auto-scaling
resource "oci_database_autonomous_database" "prod" {
  cpu_core_count = 2
  is_auto_scaling_enabled = true  # Can scale to 3× (6 OCPUs!)
}

# Cost: 2 OCPUs × $0.36 × 730 = $526/month baseline
# If auto-scales to 6 OCPUs during peak: $1,578/month (3× surprise bill!)

# SAFER - set scaling limit
# (Not available via API, must set in console: Manage Scaling → Max OCPU count)
```

**Best practice**: Set max OCPU = 2× baseline to control costs (2 OCPU → max 4 OCPU)

## Backup and Clone Patterns

### Automatic vs Manual Backup Retention

**Automatic backups** (free):
- Retention: 60 days default (configurable 1-60 days)
- Frequency: Daily incremental
- Cost: Included in ADB storage cost
- **Gotcha**: Deleting ADB deletes automatic backups after retention period

**Manual backups**:
- Retention: Until you delete them
- Cost: $0.025/GB/month (same as storage)
- **Use case**: Long-term retention (compliance, legal hold)

**Cost trap**:
```
Scenario: 1 TB ADB, keep 2 years of backups for compliance

Wrong assumption: Automatic backups are free forever
Reality: Automatic backups deleted 60 days after ADB deletion

Right approach: Manual backup before deleting ADB
Cost: $0.025/GB × 1000 GB × 24 months = $600 for 2-year retention
```

### Clone vs Refreshable Clone Decision

| | Full Clone | Refreshable Clone |
|---|------------|-------------------|
| **Use case** | Permanent dev copy | Test env needing prod data |
| **Cost** | 100% of source ADB | ~30% (storage only) |
| **Refresh** | Cannot refresh | Manual refresh from source |
| **When source deleted** | Clone survives | Clone auto-deleted |
| **Editable** | Yes | Yes (but refresh overwrites) |

**Gotcha**: Refreshable clone deleted when source ADB deleted - no warning!

**Best practice**:
- Dev environment (permanent): Full clone
- QA environment (weekly prod refresh): Refreshable clone
- Before prod migration: Full clone (survives source deletion)

## PDB Management Gotchas

**Hierarchy confusion**:
```
DB System or Exadata
└─ Container Database (CDB)
   └─ Pluggable Database (PDB)  ← Application connects here
      └─ Schemas, tables, etc.
```

**Critical**: PDB connection string uses CDB host but PDB service name
```bash
# WRONG - trying to connect to CDB
sqlplus admin/pass@cdb-host:1521/ORCLCDB

# RIGHT - connect to PDB inside CDB
sqlplus app_user/pass@cdb-host:1521/PDB1
```

**PDB lifecycle gotcha**: Unplugging PDB doesn't delete data
```bash
# Unplug PDB → creates XML metadata file
oci db pluggable-database unplug --pdb-id <ocid>
# PDB still exists in storage, can re-plug elsewhere
# Charges continue until DELETE
```

## When to Use This Skill

- Connection issues: wallet errors, service name confusion, network troubleshooting
- Cost optimization: stop/start decisions, BYOL evaluation, auto-scaling limits
- Backup/clone: choosing clone type, retention planning, disaster recovery
- PDB management: hierarchy, connection strings, unplug/plug operations
- Password errors: complexity validation, ADMIN user restrictions
- Scaling: Always-Free limits, when to scale vs stop, cost calculations
