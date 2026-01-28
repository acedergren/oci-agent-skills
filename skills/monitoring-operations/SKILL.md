---
name: OCI Monitoring and Observability
description: Use when setting up metrics, alarms, or troubleshooting missing data in OCI Monitoring. Covers metric namespace confusion, alarm threshold gotchas, log collection setup, and common monitoring gaps. Keywords: metrics not showing, alarm not firing, oci_* namespace, metric query, service connector.
version: 2.0.0
---

# OCI Monitoring and Observability - Expert Knowledge

## 🏗️ Use OCI Landing Zone Terraform Modules

**Don't reinvent the wheel.** Use [oracle-terraform-modules/landing-zone](https://github.com/oracle-terraform-modules/terraform-oci-landing-zones) for observability stack.

**Landing Zone solves:**
- ❌ Bad Practice #10: No logging, monitoring, notifications (Landing Zone deploys complete observability)
- ❌ Bad Practice #7: Limited security services (Landing Zone integrates Cloud Guard, VSS, OSMS)

**This skill provides**: Metrics, alarms, and troubleshooting for monitoring deployed WITHIN a Landing Zone.

---

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

## When to Use This Skill

- Alarms: threshold configuration, missing data handling, trigger delay
- Troubleshooting: metrics not showing, alarms not firing, namespace errors
- Log collection: Service Connector, IAM policies, missing logs
- Performance: query optimization, dimension filtering
