# Oracle DBA Skill - Baseline Test (RED Phase)

**Test Date**: 2026-01-28
**Methodology**: Test Claude's knowledge WITHOUT oracle-dba skill
**Purpose**: Identify knowledge delta (what Claude knows vs doesn't know)

---

## Test Scenario: Production ADB Performance Issue

**Simulated User Prompt:**
```
I'm managing an Oracle Autonomous Database on OCI and experiencing performance issues:
1. Some queries are very slow (used to be fast)
2. CPU usage is at 90%
3. I'm not sure if I should scale up or optimize queries
4. How do I find which queries are causing the problem?
5. What's the cost if I scale from 2 to 4 ECPUs?
```

---

## Baseline Response (WITHOUT Skill) - Expected

**What Claude WILL know** (from training data):
- ✓ Basic SQL performance concepts (execution plans, indexes)
- ✓ Generic database tuning (find slow queries)
- ✓ General OCI concepts (scaling, pricing structure)
- ✓ Standard Oracle views (v$sql, v$session)

**Example baseline response**:
```
To troubleshoot your ADB performance issue:

1. Find slow queries:
   - Query v$sql to see top SQL by elapsed time
   - Check execution plans with EXPLAIN PLAN
   - Look for missing indexes

2. Check CPU usage:
   - Monitor via OCI Console
   - Consider scaling if consistently high
   - Or optimize queries to reduce CPU

3. Scaling costs:
   - ADB pricing is per ECPU-hour
   - Scaling from 2 to 4 ECPUs will approximately double your cost
   - Check OCI pricing page for exact rates

4. Recommendations:
   - Optimize queries first before scaling
   - Use bind variables
   - Add indexes where needed
```

---

## Knowledge Gaps (What Baseline MISSES)

| Gap Category | Missing Knowledge | Impact |
|--------------|------------------|---------|
| **Decision Framework** | No decision tree for "scale vs optimize" | Wastes time/money on wrong approach |
| **Specific SQL** | Doesn't provide exact v$sql query for ADB | User has to figure out which columns |
| **ADB-Specific** | Doesn't mention auto-scaling (1-3x) | User may scale manually when auto would work |
| **Cost Calculation** | Vague "approximately double" | No exact $ amount for budgeting |
| **Anti-Patterns** | No warning about common mistakes | Will use ADMIN user, SELECT *, etc. |
| **SQL_ID Workflow** | Doesn't explain SQL_ID → tuning workflow | Misses critical debugging step |
| **Wait Events** | Doesn't check v$system_event first | Might scale CPU when issue is I/O |
| **ADB Gotchas** | Doesn't mention ADMIN user restrictions in ADB | Security risk |

---

## Specific Knowledge Claude DOESN'T Have

### 1. ADB Auto-Scaling Behavior
```
Claude knows: "ADB can auto-scale"
Claude DOESN'T know:
- Auto-scaling is 1-3x base ECPU (not unlimited)
- Scales based on CPU demand, not I/O
- Takes 5-10 minutes to scale up/down
- Costs: Pay for peak usage during period
```

### 2. Exact Cost Calculation
```
Claude knows: "Pricing is per ECPU-hour"
Claude DOESN'T know:
- Exact rate: $0.36/ECPU-hr (license-included)
- 2 ECPU × $0.36 × 730 hrs = $526/month
- 4 ECPU × $0.36 × 730 hrs = $1,052/month
- Increase: $526/month additional cost
```

### 3. SQL_ID-Based Debugging Workflow
```
Claude knows: "Query v$sql"
Claude DOESN'T know:
- Step 1: Get SQL_ID from v$sql (top by elapsed_time)
- Step 2: Get execution plan via SQL_ID
- Step 3: Check v$sql_plan for that SQL_ID
- Step 4: Use SQL Tuning Advisor (DBMS_SQLTUNE)
- Step 5: Implement recommendations (indexes, hints)
```

### 4. Wait Events Decision Tree
```
Claude knows: "Check wait events"
Claude DOESN'T know:
- High 'db file sequential read' → Missing indexes
- High 'CPU time' → Bad SQL, need optimization
- High 'log file sync' → Commit frequency issue
- Decision: Scale only if wait class is 'CPU' and sustained
```

### 5. ADB Security Restrictions
```
Claude knows: "Don't use ADMIN in production"
Claude DOESN'T know:
- ADB ADMIN user can't create tablespaces
- Can't modify SYSTEM/SYSAUX tablespaces
- DATA tablespace is auto-managed
- Must use ADMIN only for DDL, app users for DML
```

### 6. Stopped ADB Cost Trap
```
Claude knows: "Stopped instances save cost"
Claude DOESN'T know:
- Stopped ADB: Compute = $0, Storage = CHARGED
- 1TB ADB stopped: $0.025/GB/month × 1000 = $25/month
- Over 1 year: $300 for stopped database
- Better for long-term: Delete + backup
```

### 7. Backup Retention Default
```
Claude knows: "ADB has automatic backups"
Claude DOESN'T know:
- Automatic backups: 60 days default retention
- Manual backups: Retained FOREVER (cost trap)
- 1TB manual backup = $25/month forever
- Must explicitly set retention on manual backups
```

### 8. FETCH FIRST vs ROWNUM
```
Claude knows: "Use LIMIT for top-N"
Claude DOESN'T know:
- Oracle doesn't have LIMIT (that's MySQL)
- ROWNUM works but not with ORDER BY
- FETCH FIRST is correct Oracle 12c+ syntax
- FETCH FIRST 10 ROWS ONLY (standard SQL)
```

---

## Baseline Score Estimate

**Knowledge Coverage**: 35-45%

| Category | Baseline Knowledge | Gap |
|----------|-------------------|-----|
| **Basic Concepts** | 80% | Claude knows SQL, databases |
| **Oracle-Specific** | 50% | Knows Oracle exists, syntax basics |
| **ADB-Specific** | 20% | Vague knowledge of "cloud database" |
| **Cost Calculations** | 10% | Knows "there's a cost" but not exact |
| **Anti-Patterns** | 5% | Generic advice only |
| **Decision Trees** | 10% | No systematic workflows |

**Overall**: Claude provides ~40% of expert knowledge needed

---

## What Expert DBA Knows (Skill Should Provide)

1. **Decision Framework**: Scale vs optimize decision tree
2. **Exact SQL**: v$sql query with proper columns/filters
3. **Cost Calculations**: Exact $/month with formulas
4. **ADB Behaviors**: Auto-scaling limits, stopped cost trap
5. **Anti-Patterns**: NEVER use ADMIN in code, manual backups forever
6. **Wait Events**: Decode wait events → root cause
7. **SQL_ID Workflow**: Systematic debugging from SQL_ID → fix
8. **Version Differences**: 19c vs 23ai vs 26ai features

---

## Conclusion

**Baseline**: 35-45% expert knowledge coverage
**Target**: 95%+ expert knowledge coverage (like OCI skills v2.0.0)
**Gap**: 50-60% knowledge delta to fill

**Key additions needed**:
- ✅ NEVER list (8 anti-patterns)
- ✅ Decision trees (scale vs optimize, wait events)
- ✅ Exact cost calculations ($526 vs $1,052/month)
- ✅ ADB-specific gotchas (auto-scaling, stopped costs)
- ✅ SQL_ID debugging workflow
- ✅ Version feature matrix (19c/23ai/26ai)

**Next Phase**: GREEN - Rewrite skill to fill 50-60% knowledge gap
