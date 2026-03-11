---
name: oci-events
description: Use when implementing event-driven automation, setting up CloudEvents rules, troubleshooting event delivery failures, or integrating with Functions/Streaming/Notifications. Covers event rule patterns, filter syntax, action types, dead letter queue configuration, and event-driven architecture anti-patterns.
license: MIT
metadata:
  author: alexander-cedergren
  version: "2.0.0"
---

# OCI Events Service - Event-Driven Architecture

**OCI CLI/API gap**: Do NOT guess event filter syntax, event types, or confuse Events with Alarms. Use patterns from this skill and load [`events-cli.md`](references/events-cli.md) for operations.

## Use OCI Landing Zone Terraform Modules

Use Landing Zone modules instead of manually creating event rules one by one.

```hcl
# Use official OCI Landing Zone modules
module "landing_zone" {
  source  = "oracle-terraform-modules/landing-zone/oci"
  version = "~> 2.0"

  # Events configuration
  events_configuration = {
    default_compartment_id = var.security_compartment_id

    event_rules = {
      compute_instance_terminated = {
        description = "Notify when compute instance terminated"
        is_enabled  = true
        condition   = jsonencode({
          "eventType" : "com.oraclecloud.computeapi.terminateinstance"
        })
        actions = {
          notifications = [ons_topic_id]
          functions     = [security_response_function_id]
        }
      }
    }
  }
}
```

**Why Use Landing Zone Modules:**
- ✅ **Battle-tested**: Used by thousands of OCI customers
- ✅ **Compliance**: CIS OCI Foundations Benchmark aligned
- ✅ **Maintained**: Oracle updates for API changes
- ✅ **Comprehensive**: Events + IAM + Logging + Monitoring integrated
- ✅ **Reusable**: Consistent patterns across environments

**Official Resources:**
- [OCI Landing Zone Terraform Modules](https://github.com/oracle-terraform-modules/terraform-oci-landing-zones)
- [OCI Resource Manager Stacks](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/deployments.htm)
- [CIS OCI Foundation Benchmark](https://www.cisecurity.org/benchmark/oracle_cloud)

**When to Use Manual CLI** (this skill's references):
- Learning and prototyping
- Troubleshooting existing event rules
- One-off automation tasks
- Understanding event patterns before implementing in Terraform

## NEVER Do This

❌ **NEVER use Events for metric threshold monitoring (use Alarms instead)**
```
BAD - Events for CPU threshold:
Event Rule: "CPU utilization > 80%"
Problem: Events don't monitor metrics!

CORRECT tool: Alarms
oci monitoring alarm create \
  --metric-name CpuUtilization \
  --threshold 80
```

**Why critical**: Events are for **state changes** (instance created, bucket deleted), NOT continuous metrics. Using Events for thresholds wastes time—the rule will never fire.

**Events vs Alarms:**
| Use Case | Tool | Example |
|----------|------|---------|
| State change | Events | Instance terminated, bucket created, database stopped |
| Metric threshold | Alarms | CPU > 80%, disk full, memory pressure |
| Resource lifecycle | Events | VCN created, policy updated, user added |
| Performance | Alarms | Query latency > 2s, error rate > 5% |

❌ **NEVER forget to configure Dead Letter Queue (lost events)**
```bash
# BAD - no DLQ, failed events disappear
oci events rule create \
  --display-name "Invoke-Function" \
  --condition '{"eventType": "com.oraclecloud.objectstorage.createobject"}' \
  --actions '{
    "actions": [{
      "actionType": "FAAS",
      "isEnabled": true,
      "functionId": "ocid1.fnfunc.oc1..xxx"
    }]
  }'
# If function fails, event is LOST

# GOOD - DLQ configured
oci events rule create \
  --display-name "Invoke-Function-with-DLQ" \
  --condition '{"eventType": "com.oraclecloud.objectstorage.createobject"}' \
  --actions '{
    "actions": [{
      "actionType": "FAAS",
      "isEnabled": true,
      "functionId": "ocid1.fnfunc.oc1..xxx",
      "description": "Process uploaded file"
    }]
  }' \
  --compartment-id $COMPARTMENT_ID

# Separately configure DLQ (requires Streaming)
# Events that fail delivery go to stream for retry/analysis
```

**Cost impact**: Lost events = lost business transactions. E-commerce: 1 lost order event = $50-500 revenue loss. Healthcare: 1 lost patient record event = compliance violation.

❌ **NEVER use overly broad event filters (noise + cost)**
```json
// BAD - matches ALL compute events
{
  "eventType": "com.oraclecloud.computeapi.*"
}
// Fires for: launch, terminate, reboot, resize, metadata change
// Result: 1000s of events/day, function invocations cost $$$

// GOOD - specific event types
{
  "eventType": [
    "com.oraclecloud.computeapi.terminateinstance",
    "com.oraclecloud.computeapi.launchinstance"
  ]
}
// Fires only for critical lifecycle events
```

**Cost impact**: 10,000 unnecessary function invocations/day × $0.0000002/GB-second × 256MB × 5s = $2.56/day = $77/month wasted.

❌ **NEVER send sensitive data in event notification (security risk)**
```json
// BAD - event includes passwords, keys
Event payload forwarded to notification:
{
  "data": {
    "resourceName": "db-prod-1",
    "adminPassword": "SecurePass123!",  // EXPOSED!
    "apiKey": "sk_live_xxxxx"           // EXPOSED!
  }
}

// GOOD - reference-only events
{
  "data": {
    "resourceId": "ocid1.database.oc1..xxx",
    "resourceName": "db-prod-1"
    // Function retrieves secrets from Vault using resourceId
  }
}
```

**Security impact**: Notification emails/webhooks log event payload. Secrets in logs = credential exposure = breach.

❌ **NEVER use Events for real-time streaming (use Streaming service)**
```
BAD use case: Process 10,000 transactions/second via Events
Events service limits: 50 requests/second per rule
Result: Throttling, dropped events

CORRECT: OCI Streaming
- Throughput: 1 MB/second per partition
- Retention: 7 days (vs Events = deliver-once)
- Consumer groups: Multiple consumers per stream
```

**Why critical**: Events deliver to actions once (best-effort). Streaming is for high-throughput, durable messaging.

❌ **NEVER assume Events are delivered in order**
```
Event Timeline:
1. Object created at 10:00:00
2. Object updated at 10:00:01
3. Object deleted at 10:00:02

Events may arrive:
- Delete event at 10:00:03
- Create event at 10:00:04  // Out of order!
- Update event at 10:00:05

Function logic must handle out-of-order events
```

**Solution**: Include timestamp in event, check resource state before acting, or use idempotent operations.

❌ **NEVER use more than 5 actions per rule (performance)**
```bash
# BAD - 10 actions on one rule
Event Rule → 10 different functions
Latency: 10 serial invocations = 50+ seconds

# GOOD - fan-out pattern
Event Rule → 1 function → Publishes to Streaming → 10 consumers
Latency: Parallel processing = 5 seconds
```

**Limit**: 5 actions per rule (hard limit). Design for fan-out if >5 destinations needed.

❌ **NEVER forget IAM policy for event actions**
```bash
# BAD - event rule created, but no permission to invoke function
oci events rule create ... --actions function-id
# Events fire but silently fail (403 Forbidden)

# GOOD - grant Events service permission to invoke function
oci iam policy create \
  --compartment-id $COMPARTMENT_ID \
  --name "Events-Invoke-Functions-Policy" \
  --statements '[
    "Allow service cloudEvents to use functions-family in compartment <compartment-name>"
  ]'
```

**Debugging hell**: Event rule shows "active", function never triggers, no error message. Root cause: Missing IAM policy.

## Event Rule Validation Workflow

```
1. Create rule       → oci events rule create ...
2. Verify active     → oci events rule get --rule-id <ocid> --query 'data."lifecycle-state"'
3. Check IAM policy  → oci iam policy list --compartment-id <ocid> | grep cloudEvents
4. Test with event   → Trigger sample event (e.g., create test object in bucket)
5. Confirm delivery  → Check function logs or notification inbox
6. Configure DLQ     → Set up Streaming for failed event capture
```

If rule shows "ACTIVE" but function never triggers: check IAM policy first (most common root cause).

## Progressive Loading References

### Event Architecture Patterns and Filter Syntax

**WHEN TO LOAD** [`events-patterns.md`](references/events-patterns.md):
- Designing event-driven architecture (Object Storage → Function, Instance Lifecycle → Notification)
- Writing complex event filter syntax (compartment, tags, resource attributes)
- Looking up common event types by OCI service
- Understanding fan-out patterns and event chaining
- Choosing between action types (ONS vs FAAS vs OSS)

**Do NOT load** for:
- Quick anti-pattern reference (NEVER list above covers it)
- Events vs Alarms decision (covered above)
- Quick CLI examples (use events-cli.md instead)

---

### OCI CLI for Events

**WHEN TO LOAD** [`events-cli.md`](references/events-cli.md):
- Creating event rules with filters
- Configuring actions (Functions, Notifications, Streaming)
- Troubleshooting event delivery failures
- Listing available event types
- Testing event rule patterns

**Example**: Create event rule for object upload
```bash
oci events rule create \
  --display-name "Process-CSV-Uploads" \
  --condition '{
    "eventType": "com.oraclecloud.objectstorage.createobject",
    "data": {"resourceName": "*.csv"}
  }' \
  --actions '{
    "actions": [{
      "actionType": "FAAS",
      "isEnabled": true,
      "functionId": "ocid1.fnfunc.oc1..xxx"
    }]
  }' \
  --compartment-id $COMPARTMENT_ID
```

**Do NOT load** for:
- Function implementation details (covered in oci-functions skill)
- Notification topic setup (covered in monitoring-operations skill)
- Streaming configuration (covered in streaming skill when available)

---

### OCI Events Reference (Official Oracle Documentation)

**WHEN TO LOAD** [`oci-events-reference.md`](references/oci-events-reference.md):
- Need comprehensive list of all OCI service event types
- Understanding CloudEvents 1.0 specification in OCI
- Implementing complex event patterns and filtering
- Need official Oracle guidance on Events service architecture
- Troubleshooting event delivery and action failures

**Do NOT load** for:
- Quick event rule creation (CLI examples above)
- Common event patterns (architecture patterns in this skill)
- Events vs Alarms decision (decision tree above)

---

## When to Use This Skill

- Implementing event-driven automation and workflows
- Setting up serverless architectures (Events + Functions)
- Troubleshooting "event rule not firing" issues
- Integrating OCI services via events
- Designing reactive architectures (vs polling)
- Compliance and audit trail automation
- Incident response and security automation
