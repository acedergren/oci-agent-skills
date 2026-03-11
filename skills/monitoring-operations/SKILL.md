---
name: monitoring-operations
description: Use when setting up metrics, alarms, or troubleshooting missing data in OCI Monitoring. Configures alarm thresholds with proper missing-data handling, diagnoses metric namespace errors, resolves log collection gaps via Service Connector, and optimizes MQL queries with dimension filtering.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.0.0"
---

# OCI Monitoring and Observability - Expert Knowledge

## Use OCI Landing Zone Terraform Modules

Use [oracle-terraform-modules/landing-zone](https://github.com/oracle-terraform-modules/terraform-oci-landing-zones) for the observability stack. Landing Zone deploys complete observability and integrates Cloud Guard, VSS, and OSMS.

**OCI CLI/API gap**: Do NOT guess metric namespace names or assume AWS CloudWatch patterns work in OCI. Use exact commands from skill references.

## NEVER Do This

❌ **NEVER assume metrics are instant (10-15 minute lag)**
- Metrics published every 1-5 minutes
- Processing delay: 5-10 minutes
- **Total lag**: 10-15 minutes from event to visible metric
- Don't debug "missing metrics" within first 15 minutes of resource creation

❌ **NEVER use `=` for alarm thresholds with sparse metrics**
```
# WRONG - alarm never fires if metric has gaps
MetricName[1m].mean() = 0

# RIGHT - handle missing data
MetricName[1m]{dataMissing=zero}.mean() > 0
```

❌ **NEVER forget metric dimensions (causes "no data")**
```
# WRONG - missing required dimension
CPUUtilization[1m].mean()

# RIGHT - include resourceId dimension
CPUUtilization[1m]{resourceId="<instance-ocid>"}.mean()
```

❌ **NEVER set alarm thresholds without trigger delay (alert fatigue)**
```
# BAD - fires on every CPU spike
CPUUtilization[1m].mean() > 80

# BETTER - sustained high CPU
CPUUtilization[5m].mean() > 80
Trigger delay: 5 minutes (fires after 5 consecutive breaches)
```

❌ **NEVER create alarms without notification channels**
```
# WRONG - alarm fires but nobody knows
oci monitoring alarm create ... --destinations '[]'

# RIGHT - always link to notification topic
oci monitoring alarm create ... --destinations '["<notification-topic-ocid>"]'
```
Cost impact: Undetected outages cost $5,000-50,000/hour in production

❌ **NEVER ignore Cloud Guard findings (security audit failure)**
- Cloud Guard detects misconfigurations BEFORE they become incidents
- Integrate Cloud Guard → Notifications → Email/Slack/PagerDuty
- Cost impact: $100,000+ per security breach vs $0 for proactive remediation

## Metric Namespace Gotchas

**OCI Metrics Use Service-Specific Namespaces:**

| Service | Namespace | Example Metric |
|---------|-----------|----------------|
| Compute | `oci_computeagent` | `CPUUtilization`, `MemoryUtilization` |
| Autonomous DB | `oci_autonomous_database` | `CpuUtilization`, `StorageUtilization` |
| Load Balancer | `oci_lbaas` | `HttpRequests`, `UnHealthyBackendServers` |
| Object Storage | `oci_objectstorage` | `ObjectCount`, `BytesUploaded` |

**Common Mistake**: Using wrong namespace (`oci_compute` vs `oci_computeagent`)

## Alarm Missing Data Handling

| Setting | Behavior | Use When |
|---------|----------|----------|
| `treatMissingDataAsBreaching` | Alarm fires if no data | Critical services (outage = breach) |
| `treatMissingDataAsNotBreaching` | Alarm silent if no data | Optional monitoring |
| `{dataMissing=zero}` | Treat missing as 0 | Counters (requests/sec) |

## Log Collection Common Gaps

**Problem**: Logs not showing in Log Analytics

```
Logs not appearing?
├─ Is log enabled on resource?
│  └─ Compute: oci-compute-agent must be running
│  └─ Function: Logging enabled in function config
│
├─ Is Service Connector configured?
│  └─ Source: Log Group → Target: Log Analytics
│  └─ Check: Service Connector status = ACTIVE
│
├─ IAM policy for Service Connector?
│  └─ "Allow any-user to use log-content in tenancy"
│  └─ "Allow service loganalytics to READ logcontent in tenancy"
│
└─ 10-15 minute ingestion lag?
   └─ Wait before debugging
```

## Metric Query Optimization

**Expensive** (slow):
```
# Queries ALL instances
CPUUtilization[1m].mean()
```

**Optimized** (filter by dimension):
```
# Query specific instance
CPUUtilization[1m]{resourceId='<instance-ocid>'}.mean()
```

**Cost**: Queries free, but rate limited (1000 req/min)

## Alarm Setup Validation Workflow

```
1. Create alarm        → oci monitoring alarm create ...
2. Verify alarm state  → oci monitoring alarm get --alarm-id <ocid> --query 'data."lifecycle-state"'
3. Check notification  → oci ons subscription list --topic-id <topic-ocid>
4. Test delivery       → Temporarily lower threshold to trigger alarm
5. Confirm receipt     → Verify email/Slack/PagerDuty received alert
6. Restore threshold   → Set production threshold value
```

Skipping step 4-5 is the #1 cause of "alarm never fired" in production incidents.

## Progressive Loading References

### OCI Monitoring Reference (Official Oracle Documentation)

**WHEN TO LOAD** [`oci-monitoring-reference.md`](references/oci-monitoring-reference.md):
- Need comprehensive list of all OCI service metrics
- Understanding MQL (Monitoring Query Language) in depth
- Implementing complex alarm conditions and composites
- Need official Oracle guidance on Logging and Service Connector
- Setting up Log Analytics and APM integration

**Do NOT load** for:
- Quick alarm setup (examples in this skill)
- Common metric patterns (tables above)
- Troubleshooting decision trees (covered above)

---

## When to Use This Skill

- Alarms: threshold configuration, missing data handling, trigger delay
- Troubleshooting: metrics not showing, alarms not firing, namespace errors
- Log collection: Service Connector, IAM policies, missing logs
- Performance: query optimization, dimension filtering
