---
name: OCI FinOps and Cost Optimization
description: Use when optimizing OCI costs, investigating unexpected bills, planning budgets, or identifying waste. Covers hidden cost traps (boot volumes, reserved IPs, egress), Universal Credits gotchas, shape migration savings, free tier maximization, and cost allocation challenges. Keywords: unexpected charges, boot volume costs, stopped instance billing, data egress, reserved IP waste, budget exceeded.
version: 2.0.0
---

# OCI FinOps - Expert Knowledge

You are an OCI cost optimization expert. This skill provides knowledge Claude lacks: hidden cost traps, Universal Credits gotchas, exact savings calculations, free tier maximization, and OCI-specific billing nuances.

## NEVER Do This

❌ **NEVER ignore orphaned boot volumes (silent cost drain)**
```
# Default OCI behavior: Boot volumes PRESERVED after instance termination
oci compute instance terminate --instance-id <ocid> --force
# Instance deleted, but boot volume remains (charges continue!)

Cost trap:
- Boot volume: 50 GB × $0.025/GB/mo = $1.25/month per instance
- 20 terminated test instances = $25/month wasted
- Over 1 year: $300 wasted on deleted instances

# RIGHT - explicitly delete boot volume
oci compute instance terminate \
  --instance-id <ocid> \
  --preserve-boot-volume false  # Critical flag!

# Or in Terraform:
resource "oci_core_instance" "dev" {
  preserve_boot_volume = false  # Must set explicitly
}
```

**Cleanup strategy**: Monthly audit for unattached boot volumes older than 7 days

❌ **NEVER forget reserved public IPs cost money when unattached**
```
Cost: $0.01/hour = $7.30/month per IP

# Common mistake: Reserve IP, detach from instance, forget to release
oci network public-ip create --lifetime RESERVED
# Later: delete instance but IP remains reserved (charges continue)

Wasted cost example:
- 5 old reserved IPs from deleted instances
- 5 × $7.30/month = $36.50/month waste
- Over 1 year: $438 wasted

# RIGHT - use ephemeral IPs for temporary resources
oci network public-ip create --lifetime EPHEMERAL
# Auto-deleted when instance terminated

# Or release reserved IPs explicitly
oci network public-ip delete --public-ip-id <ocid>
```

**Detection**: List reserved IPs without instance attachment

❌ **NEVER assume stopped resources = zero cost**
```
Stopped Autonomous Database:
✓ Compute: Zero cost (stopped)
✗ Storage: $0.025/GB/mo continues
✗ Backups: Retention charges continue

Example: 1 TB ADB stopped for 30 days
Storage: 1000 GB × $0.025 = $25/month (charged!)

Stopped Compute Instance:
✓ Compute: Zero cost
✗ Boot volume: $0.025/GB/mo continues
✗ Block volumes: $0.025/GB/mo continues
✗ Reserved IP (if attached): $7.30/month continues

# Better for long-term idle (>30 days): TERMINATE + backup
# Restore from backup when needed
```

**Rule**: Stopped = compute paused, storage still charged

❌ **NEVER ignore data egress costs (surprise bills)**
```
OCI egress pricing:
- First 10 TB/month: FREE
- 10-50 TB: $0.0085/GB
- 50+ TB: Contact sales for discount

# Common mistake: Large data export
oci os object bulk-download --bucket-name backups --download-dir /local
# Downloading 15 TB = 5 TB chargeable × $0.0085/GB = $42,500 surprise!

# Cheaper alternatives:
1. Use OCI FastConnect (fixed cost, unlimited egress)
2. Download within same region (free between OCI services)
3. Export to another OCI region first (inter-region = free)

Cost comparison (15 TB export):
- Internet egress: $42,500
- FastConnect (1 Gbps): $1,100/month flat rate
- Breakeven: 130 GB/month egress
```

**Gotcha**: Egress is FREE between OCI regions (intra-Oracle network)

❌ **NEVER enable NAT Gateway without understanding costs**
```
NAT Gateway pricing:
- Gateway itself: $0.01/hour = $7.30/month
- Data processed: $0.01/GB

# Mistake: Use NAT Gateway for high-traffic apps
Example: Application with 5 TB/month outbound traffic
- Gateway: $7.30/month
- Data: 5000 GB × $0.01 = $50/month
- Total: $57.30/month

# Cheaper alternative: Public IP on instance (ephemeral IP = free)
Cost: $0/month for egress <10 TB

When NAT Gateway makes sense:
- Private subnets with <100 GB/month egress
- Security requirement (no public IPs on instances)

When to avoid:
- High-traffic egress (use public IPs instead)
- Low-security dev/test environments
```

❌ **NEVER over-commit with Universal Credits**
```
Universal Credits gotcha:
- Credits are NON-TRANSFERABLE between service categories
  * Compute credits → can only pay for compute
  * Database credits → can only pay for database
  * Cannot move credits between categories

# Mistake: Commit to $10k/month compute credits
# Reality: Only use $6k/month compute
# Cannot use $4k surplus for database spending
# Result: Waste $4k/month ($48k/year)

# RIGHT - commit conservatively based on baseline usage
Analyze 3-6 months historical usage
Commit to 70-80% of baseline (not peak)

Expiration gotcha:
- Monthly credits expire end of month
- Cannot roll over to next month
- Use-it-or-lose-it model
```

❌ **NEVER trust forecast budgets (30-40% error rate)**
```
OCI Budget types:
1. ACTUAL: Alerts on actual spending (accurate)
2. FORECAST: Alerts on projected spending (often wrong)

# Problem: Forecast uses simple linear projection
Example:
- Week 1: $100 spend
- Forecast for month: $100 × 4 = $400
- Reality: Week 1 included one-time data migration
- Actual month: $150 total
- Forecast error: 167% over-prediction

# WRONG - rely on forecast alerts
Alert at 80% forecast → fires prematurely

# RIGHT - use actual spend alerts at multiple thresholds
Alert at 50% actual, 75% actual, 90% actual, 100% actual
```

**Best practice**: Use FORECAST for trends, ACTUAL for budgeting

## Cost Optimization Strategies

### Shape Migration Savings (Exact Calculations)

**Fixed → Flex Shape Migration**

```
Legacy fixed shape:
VM.Standard2.4: 4 OCPUs, 60 GB RAM (fixed ratio 1:15)
Cost: $0.06/hr × 4 = $0.24/hr = $175/month

Flex shape (right-sized):
VM.Standard.E4.Flex: 4 OCPUs, 16 GB RAM (custom ratio)
Cost: ($0.02/OCPU-hr × 4) + ($0.0015/GB-hr × 16) = $0.104/hr = $76/month

Savings: $99/month per instance (56% reduction)

Migration path:
1. Create flex instance with same OCPU count
2. Test with minimal RAM (4 GB per OCPU)
3. Increase RAM only if needed
4. Delete fixed instance
```

**AMD → Arm Migration**

```
AMD instance:
VM.Standard.E4.Flex: 4 OCPUs, 16 GB RAM
Cost: $0.02/OCPU-hr × 4 × 730 = $58.40/month

Arm instance (same workload):
VM.Standard.A1.Flex: 4 OCPUs, 16 GB RAM
Cost: $0.01/OCPU-hr × 4 × 730 = $29.20/month

Savings: $29.20/month per instance (50% reduction)

Gotcha: ARM64 architecture (not all apps compatible)
Check: Docker images available for ARM64?
```

### Free Tier Maximization

**Exact cost avoidance** (what you DON'T pay):

```
Always-Free tier value if fully utilized:

Compute:
- 2 AMD Micro VMs: 2 × $7/month = $14/month
- 4 Arm OCPUs (24 GB): 4 × $7.30/month = $29.20/month
Subtotal: $43.20/month

Database:
- 2 Autonomous Databases: 2 × $292/month = $584/month

Storage:
- 200 GB block: $5/month
- 10 GB object: $0.26/month
- 10 GB archive: $0.02/month
Subtotal: $5.28/month

Networking:
- 1 load balancer: $10/month
- 10 TB egress: $85/month
Subtotal: $95/month

TOTAL COST AVOIDED: $727.48/month ($8,730/year)
```

**Gotcha**: 2 ADB limit is TENANCY-wide (not per region/compartment)

### Storage Lifecycle Optimization

**Automated tiering savings**:

```
Scenario: 10 TB compliance data, accessed quarterly

Without tiering (all Standard):
10,000 GB × $0.0255/GB/mo = $255/month = $3,060/year

With tiering (Archive after 30 days):
Month 1 (Standard): 10,000 GB × $0.0255 = $255
Months 2-12 (Archive): 10,000 GB × $0.0024 × 11 = $264
Total year: $519

Savings: $2,541/year (83% reduction)

Lifecycle policy:
- Day 0-30: Standard (frequent access window)
- Day 31+: Archive (compliance retention)
- Retrieval cost: $0.01/GB (acceptable for quarterly access)
```

### Compute Auto-Shutdown Savings

**Dev/test environment automation**:

```
Scenario: 10 development instances, 2 OCPUs each
Running 24/7: 10 × 2 × $0.02/hr × 730 = $292/month

Auto-shutdown (weekdays 9am-6pm only):
Usage: 9 hours/day × 5 days = 45 hours/week = 195 hours/month
Cost: 10 × 2 × $0.02/hr × 195 = $78/month

Savings: $214/month (73% reduction)

Implementation:
1. Tag instances: Environment=Development
2. Create Functions for start/stop
3. Schedule with OCI Events:
   - Start: Weekdays 9am
   - Stop: Weekdays 6pm
```

## Universal Credits Gotchas

**Credit categories** (non-transferable):

| Category | Services Included | Typical Use |
|----------|------------------|-------------|
| **Compute** | VM, bare metal, container instances, OKE | Applications, workloads |
| **Database** | ADB, DB Systems, Exadata, MySQL | Data storage, transactions |
| **Storage** | Block, object, file, archive | Backups, data lakes |
| **Network** | Load balancer, FastConnect, NAT GW | Connectivity, egress |

**Commitment trap**:

```
Scenario: Commit to $5k/month database credits
Month 1-3: Use only $3k/month (waste $2k/month)
Cannot: Transfer $2k to compute spending
Result: Waste $6k over 3 months

Better approach:
1. Analyze 6 months baseline usage per category
2. Commit to 70% of baseline (room for variance)
3. Over-commit only if growth guaranteed
```

**Expiration**: Monthly credits = use-it-or-lose-it (no rollover)

## Cost Allocation Challenges

**Shared resource allocation** (OCI-specific):

```
Problem: How to allocate costs for shared VCN?

VCN costs:
- DRG: $0.01/hr = $7.30/month
- NAT Gateway: $0.01/hr + $0.01/GB = variable
- FastConnect: $1,100/month (1 Gbps)

Allocation strategies:
1. Equal split: $1,107.30 / N teams
2. Usage-based: Track egress per team (requires tagging)
3. Chargeback: Production pays 100%, dev/test free

Gotcha: OCI doesn't auto-allocate shared resource costs
Must implement manual showback/chargeback process
```

**Load balancer cost allocation**:

```
Problem: Multiple apps share 1 load balancer

LB costs:
- Flexible LB: $10/month + $0.008/LCU-hour
- Bandwidth: $0.01/GB processed

Allocation approach:
1. Tag backends by team (freeform_tags.Team)
2. Estimate traffic % per team (monitoring metrics)
3. Allocate LB cost proportionally

Example:
- Total LB cost: $50/month
- Team A: 60% traffic → $30/month
- Team B: 40% traffic → $20/month
```

## Budget Best Practices

**Multi-threshold alerts**:

```
# Best practice: Set 4 alert levels
oci budgets alert-rule create \
  --budget-id <ocid> \
  --type ACTUAL \
  --threshold 50 \
  --recipients "team@example.com"

oci budgets alert-rule create \
  --budget-id <ocid> \
  --type ACTUAL \
  --threshold 80 \
  --recipients "team@example.com,manager@example.com"

oci budgets alert-rule create \
  --budget-id <ocid> \
  --type ACTUAL \
  --threshold 90 \
  --recipients "team@example.com,manager@example.com,finance@example.com"

oci budgets alert-rule create \
  --budget-id <ocid> \
  --type ACTUAL \
  --threshold 100 \
  --recipients "team@example.com,manager@example.com,finance@example.com"

Alert strategy:
50%: FYI to team (informational)
80%: Action required (investigate spike)
90%: Escalation to management
100%: Finance involved (budget exceeded)
```

**Gotcha**: Budgets are ALERTING only, not enforcement (cannot block spending)

## Hidden Cost Detection

**Monthly audit checklist**:

```bash
# 1. Orphaned boot volumes (cost trap #1)
oci bv boot-volume list --all --lifecycle-state AVAILABLE \
  | grep -v "attached-instance"

# 2. Unattached block volumes
oci bv volume list --all --lifecycle-state AVAILABLE

# 3. Reserved IPs without instance
oci network public-ip list --scope REGION --lifetime RESERVED

# 4. Stopped instances with volumes
oci compute instance list --lifecycle-state STOPPED

# 5. Old snapshots/backups
oci bv backup list --all \
  | jq '.data[] | select(.["time-created"] < "2024-01-01")'

# 6. Unused load balancers (no backends)
oci lb load-balancer list --all

# 7. Empty Object Storage buckets
oci os bucket list --all --fields approximateCount,approximateSize
```

**Estimated monthly savings**: $100-500 for typical tenancy (cleanup waste)

## When to Use This Skill

- Unexpected bills: Investigating charges, finding cost spikes
- Budget planning: Estimating costs, setting budgets, forecasting
- Cost optimization: Right-sizing, waste reduction, shape migration
- Free tier: Maximizing always-free usage, avoiding over-provisioning
- Universal Credits: Commitment planning, credit allocation
- Cost allocation: Showback, chargeback, shared resource costs
- Savings calculations: Comparing options, ROI analysis
