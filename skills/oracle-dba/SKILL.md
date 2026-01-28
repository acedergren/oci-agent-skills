---
name: OCI Oracle DBA and DevOps
description: Use when managing Oracle Autonomous Database on OCI, troubleshooting performance issues, optimizing costs, or implementing HA/DR. Covers ADB-specific gotchas, cost traps, SQL_ID debugging workflows, auto-scaling behavior, and version differences (19c/21c/23ai/26ai). Keywords: slow query, SQL_ID, ECPU scaling, stopped ADB cost, ADMIN user restrictions, auto-scaling limits.
version: 2.0.0
---

# OCI Oracle DBA - Expert Knowledge

You are an Oracle Autonomous Database expert on OCI. This skill provides knowledge Claude lacks: ADB-specific behaviors, cost traps, SQL_ID debugging workflows, auto-scaling gotchas, and production anti-patterns.

## NEVER Do This

❌ **NEVER use ADMIN user in application code**
```sql
-- WRONG - application uses ADMIN credentials
app_config = {'user': 'ADMIN', 'password': admin_pwd}

-- RIGHT - create app-specific user with least privilege
CREATE USER app_user IDENTIFIED BY :password;
GRANT CREATE SESSION, SELECT ON schema.* TO app_user;
```

**Why critical**: ADMIN has full database control, audit trail shows all actions as ADMIN (no accountability), ADMIN can't be locked/disabled without breaking automation.

❌ **NEVER scale without checking wait events first**
```
-- WRONG decision path: "CPU is high → scale ECPUs"

-- RIGHT decision path:
1. Check v$system_event for top wait events
2. High 'CPU time' wait → Bad SQL, need optimization (DON'T scale)
3. High 'db file sequential read' → Missing indexes (DON'T scale)
4. High 'User I/O' sustained → Scale storage IOPS OR auto-scaling
5. Only scale ECPUs if: CPU wait sustained + SQL already optimized
```

**Cost impact**: Scaling 2→4 ECPU = $526/month increase. If root cause is bad SQL, wasted $526/month.

❌ **NEVER assume stopped ADB = zero cost**
```
Stopped Autonomous Database charges:
✓ Compute: $0 (stopped)
✗ Storage: $0.025/GB/month continues
✗ Backups: Retention charges continue

Example: 1TB ADB stopped for 30 days
Storage: 1000 GB × $0.025 = $25/month (CHARGED!)

Better for long-term idle (>60 days):
1. Export data (Data Pump)
2. Delete ADB
3. Restore from backup when needed
```

❌ **NEVER forget retention on manual backups (cost trap)**
```bash
# WRONG - manual backup with no retention (kept forever)
oci db autonomous-database-backup create \
  --autonomous-database-id $ADB_ID \
  --display-name "pre-upgrade-backup"
# Cost: $0.025/GB/month FOREVER

# RIGHT - set retention
oci db autonomous-database-backup create \
  --autonomous-database-id $ADB_ID \
  --display-name "pre-upgrade-backup" \
  --retention-days 30

Cost trap: 1TB manual backup × $0.025/GB/month × 12 months = $300/year waste
```

❌ **NEVER use SELECT * in production queries**
```sql
-- WRONG - fetches all columns, heavy network/parsing
SELECT * FROM orders WHERE customer_id = :cust_id;

-- RIGHT - specify needed columns
SELECT order_id, total_amount, status FROM orders WHERE customer_id = :cust_id;

Impact: 50-column table, fetching 5 needed columns
- SELECT *: 50 columns × 1000 rows = 50k data points
- Explicit: 5 columns × 1000 rows = 5k data points (90% reduction)
```

❌ **NEVER ignore SQL_ID when debugging slow queries**
```sql
-- WRONG - "my query is slow, tune the database"
ALTER SYSTEM SET optimizer_mode = 'FIRST_ROWS';  # Affects ALL queries!

-- RIGHT - identify specific SQL_ID, tune that query
SELECT sql_id, elapsed_time/executions/1000 AS avg_ms, executions
FROM v$sql
WHERE executions > 0
ORDER BY elapsed_time DESC
FETCH FIRST 10 ROWS ONLY;

Then tune specific SQL_ID (not entire database)
```

❌ **NEVER use ROWNUM with ORDER BY (wrong results)**
```sql
-- WRONG - ROWNUM applied BEFORE ORDER BY (wrong top 10)
SELECT * FROM orders WHERE ROWNUM <= 10 ORDER BY created_at DESC;

-- RIGHT - FETCH FIRST (Oracle 12c+)
SELECT * FROM orders ORDER BY created_at DESC FETCH FIRST 10 ROWS ONLY;
```

❌ **NEVER scale auto-scaling ADB without checking current behavior**
```
ADB Auto-Scaling Gotcha:
- Base ECPU: 2
- Auto-scaling: Scales 1-3x (2 → 6 ECPU max)
- Cost: Charged for PEAK usage during period

# WRONG - enable auto-scaling then forget about it
Cost surprise: Base 2 ECPU ($526/month) → Peak 6 ECPU ($1,578/month)

# RIGHT - set max ECPU limit in console
Max ECPU = 4 (2× base, not 3×)
Cost control: Peak 4 ECPU ($1,052/month) max
```

## Performance Troubleshooting Decision Tree

```
"Queries are slow"?
│
├─ Is it ONE query or ALL queries?
│  ├─ ONE query slow
│  │  └─ Get SQL_ID from v$sql (top by elapsed_time)
│  │     └─ Check execution plan:
│  │        SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id'));
│  │        ├─ Full table scan? → Add index
│  │        ├─ Wrong join order? → Use hints or SQL Plan Management
│  │        └─ Cartesian join? → Fix query logic
│  │
│  └─ ALL queries slow (system-wide)
│     └─ Check wait events:
│        SELECT event, time_waited_micro/1000000 AS wait_sec
│        FROM v$system_event
│        WHERE wait_class != 'Idle'
│        ORDER BY time_waited_micro DESC
│        FETCH FIRST 10 ROWS ONLY;
│
│        ├─ Top wait: 'CPU time' → Optimize SQL OR scale ECPU
│        ├─ Top wait: 'db file sequential read' → Missing indexes
│        ├─ Top wait: 'db file scattered read' → Full table scans
│        ├─ Top wait: 'log file sync' → Too many commits (batch)
│        └─ Top wait: 'User I/O' → Scale storage IOPS or auto-scale
│
└─ When did slowness start?
   ├─ After schema change? → Gather stats (DBMS_STATS)
   ├─ After data load? → Gather stats + check partitioning
   ├─ After version upgrade? → Check execution plan changes
   └─ Gradual over time? → Data growth, need indexing/partitioning
```

## ADB Cost Calculations (Exact)

### ECPU Scaling Cost

```
License-Included pricing: $0.36/ECPU-hour
BYOL pricing: $0.18/ECPU-hour (if you have Oracle licenses)

Monthly cost = ECPU count × hourly rate × 730 hours

Examples:
2 ECPU: 2 × $0.36 × 730 = $526/month
4 ECPU: 4 × $0.36 × 730 = $1,052/month
8 ECPU: 8 × $0.36 × 730 = $2,104/month

BYOL (50% off):
2 ECPU: 2 × $0.18 × 730 = $263/month
4 ECPU: 4 × $0.18 × 730 = $526/month
```

### Storage Cost

```
Storage pricing: $0.025/GB/month (all tiers: Standard, Archive)

Examples:
1 TB: 1000 GB × $0.025 = $25/month
5 TB: 5000 GB × $0.025 = $125/month

CRITICAL: Storage charged even when ADB stopped!
```

### Auto-Scaling Cost Impact

```
Scenario: Base 2 ECPU with auto-scaling enabled (1-3×)

Without auto-scaling:
2 ECPU × $0.36 × 730 = $526/month (fixed)

With auto-scaling (spiky load):
- 50% of time: 2 ECPU = $263
- 30% of time: 4 ECPU = $315
- 20% of time: 6 ECPU = $315
Monthly cost: $893 (70% increase)

When auto-scaling makes sense:
- Spiky load (not sustained high)
- Want to avoid manual scaling
- Cost increase acceptable (up to 3×)
```

## SQL_ID Debugging Workflow

**Step 1: Find problem SQL_ID**
```sql
SELECT sql_id,
       elapsed_time/executions/1000 AS avg_ms,
       executions,
       sql_text
FROM v$sql
WHERE executions > 0
  AND last_active_time > SYSDATE - 1/24  -- Last hour
ORDER BY elapsed_time DESC
FETCH FIRST 10 ROWS ONLY;
```

**Step 2: Get execution plan**
```sql
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id'));
```

**Step 3: Analyze plan issues**
- `TABLE ACCESS FULL` on large table → Missing index
- `NESTED LOOPS` with high cardinality → Wrong join method
- `HASH JOIN OUTER` → Consider index join

**Step 4: Create SQL Tuning Task**
```sql
DECLARE
  task_name VARCHAR2(30);
BEGIN
  task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK(
    sql_id => '&sql_id',
    task_name => 'tune_slow_query'
  );
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name);
END;
/

-- Get recommendations
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK('tune_slow_query') FROM DUAL;
```

**Step 5: Implement fix**
- Recommendation: Add index → Create index
- Recommendation: Use hint → Test with hint, then SQL Plan Baseline
- Recommendation: Gather stats → `EXEC DBMS_STATS.GATHER_TABLE_STATS`

## ADB-Specific Behaviors (OCI Gotchas)

### Auto-Scaling Limits

```
Auto-scaling rules (cannot change):
- Minimum: 1× base ECPU
- Maximum: 3× base ECPU
- Scaling trigger: CPU > 80% for 5+ minutes
- Scale-down: CPU < 60% for 10+ minutes
- Time to scale: 5-10 minutes

Example: Base 2 ECPU
- Can scale: 2 → 4 → 6 ECPU
- Cannot scale: Beyond 6 ECPU (hard limit)
- Cost: Pay for peak usage each hour
```

### ADMIN User Restrictions

```
In Autonomous Database, ADMIN user:
✓ Can: Create users, grant roles, DDL operations
✗ Cannot: Create tablespaces (DATA is auto-managed)
✗ Cannot: Modify SYSTEM/SYSAUX tablespaces
✗ Cannot: Access OS (no shell, no file system)
✗ Cannot: Use SYSDBA privileges (not available in ADB)

For applications:
- ADMIN: Only for database setup/maintenance
- App users: Create dedicated users with minimal grants
```

### Service Name Performance Impact

```
ADB provides 3 service names per database:

| Service | CPU Allocation | Concurrency | Use For |
|---------|---------------|-------------|---------|
| HIGH | Dedicated OCPU | 1× ECPU | Interactive queries, OLTP |
| MEDIUM | Shared OCPU | 2× ECPU | Reporting, batch jobs |
| LOW | Most sharing | 3× ECPU | Background tasks, ETL |

Cost: All service names use same ECPU pool (no extra cost)
Performance: HIGH is faster but limits concurrency
Gotcha: Using HIGH for background jobs wastes resources
```

### Backup Retention (Automatic vs Manual)

```
Automatic backups (free, included):
- Frequency: Daily incremental, weekly full
- Retention: 60 days default (configurable 1-60)
- Cost: Included in ADB storage cost
- Deletion: Automatic after retention period

Manual backups (charged separately):
- Frequency: On-demand
- Retention: FOREVER (until you delete)
- Cost: $0.025/GB/month
- Deletion: Manual only

Cost trap: 10 manual backups × 1TB × $0.025/GB/month = $250/month
Recommendation: Use automatic backups, manual only for long-term archival
```

## Version-Specific Features (Know Which ADB Version)

| Feature | 19c | 21c | 23ai | 26ai | When to Use |
|---------|-----|-----|------|------|-------------|
| **JSON Relational Duality** | - | - | ✓ | ✓ | Modern apps (REST + SQL) |
| **AI Vector Search** | - | - | ✓ | ✓ | RAG, semantic search |
| **JavaScript Stored Procs** | - | - | - | ✓ | Node.js developers |
| **SELECT AI** | - | - | ✓ | ✓ | Natural language → SQL |
| **Property Graphs** | - | ✓ | ✓ | ✓ | Fraud detection, social |
| **True Cache** | - | - | - | ✓ | Read-heavy workloads |
| **Blockchain Tables** | - | ✓ | ✓ | ✓ | Immutable audit log |

**Upgrade path**: 19c → 21c → 23ai → 26ai
**Downgrade**: NOT supported (cannot go back)
**Recommendation**: Test in clone before upgrading production

## Common ADB Errors Decoded

| Error Message | Actual Cause | Solution |
|---------------|--------------|----------|
| `ORA-01017: invalid username/password` | Wallet password wrong OR expired credentials | Re-download wallet, check password |
| `ORA-12170: Connect timeout` | Network issue OR wrong service name | Check NSG rules, verify tnsnames.ora |
| `ORA-00604: error at recursive SQL level 1` | Automated task failed (stats gather, space mgmt) | Check DBA_SCHEDULER_JOB_RUN_DETAILS |
| `ORA-30036: unable to extend segment` | Tablespace full (DATA auto-managed) | ADB auto-extends, if error persists → contact support |
| `ORA-01031: insufficient privileges` | ADMIN user trying restricted operation | Use ADMIN only for allowed operations (see restrictions) |

## When to Use This Skill

- Performance issues: Slow queries, high CPU, scaling decisions
- Cost optimization: ECPU sizing, stopped ADB charges, backup retention
- Debugging: SQL_ID workflow, wait events, execution plans
- Auto-scaling: When to enable, cost impact, limits
- Version planning: Feature comparison (19c vs 26ai), upgrade timing
- Security: ADMIN restrictions, user setup, service name selection
