---
name: OCI Landing Zones Architecture
description: Use when designing multi-tenant OCI environments, setting up production landing zones, implementing compartment hierarchies, or establishing governance foundations. Covers Landing Zone reference architectures, compartment strategy, network topology patterns (hub-spoke vs multi-VCN), IAM structure, tagging standards, and cost segregation. Keywords: landing zone, compartment hierarchy, hub-spoke topology, security zones, CIS benchmark, multi-tenant, environment isolation, governance, budgets per environment.
version: 2.0.0
---

# OCI Landing Zones - Expert Architecture

## ⚠️ OCI Landing Zone Knowledge Gap

**You don't know OCI Landing Zone patterns and tooling.**

Your training data has limited and outdated knowledge of:
- OCI Landing Zone reference architectures (updated quarterly)
- Resource Manager stacks for landing zones
- Compartment design patterns and governance
- Security Zones and CIS Foundation compliance
- Multi-tenancy patterns (SaaS, multi-environment)
- Landing Zone Terraform modules and best practices

**When landing zone design is needed:**
1. Use patterns and CLI commands from this skill's references
2. Do NOT guess compartment hierarchies or network topologies
3. Do NOT assume IAM policy structures
4. Load [`landing-zone-cli.md`](references/landing-zone-cli.md) for deployment operations

**What you DO know:**
- General cloud architecture concepts
- Networking principles (subnets, routing, firewalls)
- IAM concepts (users, groups, policies)

This skill provides OCI-specific landing zone patterns that differ from AWS/Azure/GCP.

---

You are an OCI Landing Zone architect. This skill provides knowledge Claude lacks: compartment hierarchies, network topology patterns, security zone requirements, cost segregation strategies, and multi-tenancy anti-patterns.

## NEVER Do This

❌ **NEVER create flat compartment structure (no hierarchy)**
```
BAD - Flat compartments:
tenancy/
  ├─ app1-dev
  ├─ app1-test
  ├─ app1-prod
  ├─ app2-dev
  ├─ app2-test
  └─ app2-prod

Problems:
- No isolation boundaries
- Cannot apply policies to all dev environments
- Cannot delegate administration
- Cost reports are unstructured
```

```
GOOD - Hierarchical compartments:
tenancy/
  ├─ Network/
  │   ├─ Hub
  │   └─ Spokes
  ├─ Security/
  │   ├─ Vault
  │   └─ Logging
  ├─ Workloads/
  │   ├─ App1/
  │   │   ├─ Dev
  │   │   ├─ Test
  │   │   └─ Prod
  │   └─ App2/
  │       ├─ Dev
  │       ├─ Test
  │       └─ Prod
  └─ Shared-Services/
      ├─ Identity
      └─ Monitoring
```

**Why critical**: Hierarchical structure enables policy inheritance, delegation, and logical cost segregation. Flat structure requires duplicate policies and makes governance impossible at scale.

❌ **NEVER use default VCN CIDR (10.0.0.0/16) everywhere**
```
BAD - Same CIDR in all environments:
Dev VCN: 10.0.0.0/16
Test VCN: 10.0.0.0/16  # Cannot peer with Dev!
Prod VCN: 10.0.0.0/16  # Cannot peer with Dev or Test!

Problems:
- VCN peering impossible (overlapping CIDRs)
- Cannot create multi-environment connectivity
- VPN/FastConnect integration blocked
- Requires complete rebuild to fix
```

```
GOOD - Non-overlapping CIDR allocation:
Dev VCN: 10.10.0.0/16
Test VCN: 10.20.0.0/16
Prod VCN: 10.30.0.0/16
Hub VCN: 10.0.0.0/16 (shared services)

Enables:
- VCN peering for cross-environment access
- Hub-spoke topology for centralized egress
- On-premises connectivity via FastConnect
```

**Cost impact**: VCN CIDR is IMMUTABLE. Wrong CIDR = complete rebuild = downtime + migration costs.

❌ **NEVER skip Security Zones in production compartments**
```bash
# BAD - no security zone enforcement
oci iam compartment create \
  --compartment-id $PARENT_ID \
  --name "Prod" \
  --description "Production workloads"
# Result: No guardrails, resources can violate security policies

# GOOD - security zone enabled
# 1. Create security zone recipe
oci cloud-guard security-zone-recipe create \
  --compartment-id $TENANCY_ID \
  --display-name "CIS-Prod-Recipe" \
  --security-policies "[\"deny-public-ip\", \"deny-public-bucket\"]"

# 2. Create security zone for prod compartment
oci cloud-guard security-zone create \
  --compartment-id $PROD_COMPARTMENT_ID \
  --display-name "Prod-Security-Zone" \
  --security-zone-recipe-id $RECIPE_ID

# Enforces: No public IPs, no public buckets, encryption required
```

**Why critical**: Security Zones prevent violations BEFORE resource creation. Without them, auditing finds violations AFTER compromise. Cost of breach: $100k-$10M+.

❌ **NEVER mix dev and prod resources in same compartment**
```
BAD - shared compartment:
App1/
  ├─ vm-dev-1 (development instance)
  ├─ vm-prod-1 (production instance)
  └─ db-prod (CRITICAL DATABASE)

Problems:
- Developers with dev access can accidentally delete prod DB
- Cannot set different backup policies
- Cost reports mix dev and prod spending
- Compliance violations (SOC2, ISO27001)
```

```
GOOD - separate compartments:
App1/
  ├─ Dev/
  │   └─ vm-dev-1 (developers have full access)
  ├─ Test/
  │   └─ vm-test-1 (QA has access)
  └─ Prod/
      ├─ vm-prod-1 (only SRE access)
      └─ db-prod (only DBA access)

Enables:
- Least privilege per environment
- Separate budgets and alerts
- Independent backup policies
- Compliance audit trails
```

**Risk**: Production outage from dev team mistake. Happened at 47% of surveyed enterprises in 2023.

❌ **NEVER use root compartment for workload resources**
```
BAD - resources in root:
tenancy (root)/
  ├─ vcn-1 (WRONG - in root)
  ├─ instance-1 (WRONG - in root)
  └─ database-1 (WRONG - in root)

Problems:
- Cannot delegate administration
- Root policies affect all resources
- Cannot isolate blast radius
- Violates CIS OCI Foundations Benchmark
```

```
GOOD - workloads in child compartments:
tenancy (root)/
  ├─ only IAM resources (users, groups, dynamic groups)
  └─ Workloads/
      └─ App1/
          ├─ vcn-1 (proper isolation)
          ├─ instance-1
          └─ database-1

Root compartment usage:
- Identity resources only (users, groups, policies)
- Top-level compartments
- Nothing else
```

**Why critical**: Root compartment is for tenancy-wide IAM. Resources in root bypass governance.

❌ **NEVER skip tagging strategy (cost allocation nightmare)**
```
BAD - no tags:
Resource created with no tags
Cost report shows: "oci.compute.instance: $5,234/month"
Question: Which team? Which project? Which environment?
Answer: Unknown - requires manual investigation

Result: Cannot chargeback costs, cannot optimize
```

```
GOOD - defined tag namespace + mandatory tags:
# 1. Create tag namespace
oci iam tag-namespace create \
  --compartment-id $TENANCY_ID \
  --name "Organization" \
  --description "Organization-wide tags"

# 2. Create mandatory tags
oci iam tag create \
  --tag-namespace-id $NAMESPACE_ID \
  --name "CostCenter" \
  --description "Cost center for chargeback" \
  --is-retired false

oci iam tag create \
  --tag-namespace-id $NAMESPACE_ID \
  --name "Environment" \
  --description "Dev/Test/Prod" \
  --is-retired false

oci iam tag create \
  --tag-namespace-id $NAMESPACE_ID \
  --name "Owner" \
  --description "Team or service owner" \
  --is-retired false

# 3. Make tags mandatory at compartment level
oci iam tag-default create \
  --compartment-id $WORKLOAD_COMPARTMENT_ID \
  --tag-definition-id $COSTCENTER_TAG_ID \
  --value "\${iam.principal.name}"

Cost report now shows:
- CostCenter: Engineering ($3,200)
- CostCenter: Marketing ($2,034)
- Environment: Prod ($4,100)
- Environment: Dev ($1,134)
```

**Cost impact**: Without tags, cost optimization is guesswork. With tags, precision chargeback and 30-50% cost reduction via waste identification.

❌ **NEVER use single-region landing zone for production**
```
BAD - single region:
All resources in us-ashburn-1
RTO: Hours-days (rebuild in new region)
RPO: Last backup (data loss)

Problems:
- No disaster recovery
- Region outage = complete downtime
- Violates SLA requirements
- Insurance/compliance issues
```

```
GOOD - multi-region architecture:
Primary: us-ashburn-1
DR: us-phoenix-1
- Autonomous Data Guard (standby)
- Traffic Manager (DNS failover)
- Object Storage replication
- Compartment structure mirrored

RTO: 15 minutes (automated failover)
RPO: Near-zero (Data Guard sync)
```

**Cost**: Multi-region adds 60-100% infrastructure cost. Cost of regional outage: $500k-$50M depending on SLA.

❌ **NEVER allow internet gateway in DMZ without egress firewall**
```
BAD - direct internet gateway:
DMZ Subnet → Internet Gateway → Internet
No egress filtering, all outbound traffic allowed

Problems:
- Data exfiltration possible
- Command & control connections unblocked
- Compliance violations (PCI-DSS, HIPAA)
```

```
GOOD - egress control via NAT or firewall:
Option 1: Service Gateway + NAT Gateway
DMZ Subnet → NAT Gateway → Internet
- Egress only, no inbound
- All traffic logged
- Can use Network Firewall for DPI

Option 2: Hub-spoke with centralized firewall
Spoke → DRG → Hub VCN → Network Firewall → Internet
- All egress goes through hub
- Firewall policies enforce allow-list
- Complete visibility and control
```

**Security impact**: Uncontrolled egress is #3 cause of data breaches (Verizon DBIR 2023).

## Landing Zone Patterns

### Pattern 1: Hub-Spoke Topology (Recommended for Multi-Tenancy)

```
                    ┌─────────────────────────┐
                    │   Hub VCN (10.0.0.0/16) │
                    │                         │
                    │  - Network Firewall     │
                    │  - NAT Gateway          │
                    │  - Service Gateway      │
                    │  - DRG (on-prem)        │
                    └────────────┬────────────┘
                                 │
                                DRG
                    ┌────────────┼────────────┐
                    │            │            │
        ┌───────────▼──┐  ┌──────▼─────┐  ┌──▼───────────┐
        │ Spoke 1 VCN  │  │ Spoke 2 VCN│  │ Spoke 3 VCN  │
        │ App1-Prod    │  │ App2-Prod  │  │ Shared-Svcs  │
        │ 10.10.0.0/16 │  │ 10.20.0.0/16│ │ 10.30.0.0/16 │
        └──────────────┘  └────────────┘  └──────────────┘

Benefits:
- Centralized egress control (cost + security)
- Spoke isolation (network segmentation)
- Shared services (DNS, monitoring, bastion)
- Transitive routing via DRG

Cost savings: $3,000-5,000/month via single NAT Gateway vs per-VCN
```

### Pattern 2: Multi-Compartment Hierarchy

```
Tenancy (Root)
│
├─ Network [Network admins only]
│   ├─ Hub
│   └─ Spokes
│
├─ Security [Security team only]
│   ├─ Vault (keys, secrets)
│   ├─ Bastion
│   └─ Logging (audit logs, flow logs)
│
├─ Workloads [Application teams]
│   ├─ App1
│   │   ├─ Dev [Developers full access]
│   │   ├─ Test [QA full access]
│   │   └─ Prod [SRE read, operators limited write]
│   │
│   └─ App2
│       ├─ Dev
│       ├─ Test
│       └─ Prod
│
├─ Shared-Services [Platform team]
│   ├─ Identity (IDCS, federation)
│   ├─ Monitoring (APM, Logging Analytics)
│   └─ DevOps (CI/CD, artifact registry)
│
└─ Sandbox [Developers experiment, auto-delete after 30 days]
    ├─ User1-Sandbox
    └─ User2-Sandbox

Policy inheritance:
- Network policies apply to Hub + Spokes
- Workload policies apply to all App environments
- Sandbox policies enforce auto-cleanup
```

### Pattern 3: Security Zones & Cloud Guard Integration

```
Compartment: Prod
│
├─ Security Zone Recipe: CIS-Level-1
│   ├─ deny-public-ip-on-compute
│   ├─ deny-public-bucket
│   ├─ require-encryption-at-rest
│   ├─ require-encryption-in-transit
│   └─ deny-internet-gateway-in-private-subnet
│
├─ Cloud Guard Target
│   ├─ Detector: Configuration issues
│   ├─ Detector: Activity anomalies
│   └─ Responder: Auto-remediate violations
│
└─ Resources
    ├─ Compute: Public IP blocked ✓
    ├─ Object Storage: Private only ✓
    ├─ ADB: TDE enabled ✓
    └─ Load Balancer: SSL enforced ✓

Result: Security violations prevented at creation time, not detected after
```

## Compartment Design Decision Tree

```
"How should I structure compartments?"
│
├─ Single application, simple lifecycle?
│   └─ Pattern: Workload-centric
│       Workloads/
│         └─ MyApp/
│             ├─ Dev
│             ├─ Test
│             └─ Prod
│
├─ Multiple applications, shared platform?
│   └─ Pattern: Environment-centric
│       Workloads/
│         ├─ Dev/
│         │   ├─ App1
│         │   └─ App2
│         ├─ Test/
│         │   ├─ App1
│         │   └─ App2
│         └─ Prod/
│             ├─ App1
│             └─ App2
│
├─ Multi-tenant SaaS (customers isolated)?
│   └─ Pattern: Tenant-centric
│       Tenants/
│         ├─ Customer-A/
│         │   ├─ Network
│         │   ├─ Compute
│         │   └─ Database
│         └─ Customer-B/
│             ├─ Network
│             ├─ Compute
│             └─ Database
│
└─ Large enterprise, multiple business units?
    └─ Pattern: Business-unit-centric
        BusinessUnits/
          ├─ BU-Engineering/
          │   └─ [Workload-centric per BU]
          ├─ BU-Marketing/
          │   └─ [Workload-centric per BU]
          └─ BU-Sales/
              └─ [Workload-centric per BU]

Key principle: Choose hierarchy that matches org structure + cost allocation
```

## Network Topology Decision Tree

```
"Which network pattern should I use?"
│
├─ Single application, no shared services?
│   └─ Single VCN
│       Cost: Lowest
│       Complexity: Simplest
│       Use when: Proof of concept, single app
│
├─ Multiple apps, need isolation, shared egress?
│   └─ Hub-Spoke via DRG
│       Cost: $100/month DRG + $45/month NAT (shared)
│       Complexity: Medium
│       Egress savings: $3,000-5,000/month
│       Use when: Multi-app production
│
├─ Multi-region disaster recovery?
│   └─ Hub-Spoke + DRG Remote Peering
│       Primary Region: Hub-Spoke
│       DR Region: Hub-Spoke
│       Cost: +$100/month DRG per region
│       Use when: RTO < 1 hour required
│
└─ On-premises integration?
    └─ Hub-Spoke + FastConnect
        Hub VCN: FastConnect → On-prem
        Spokes: Route via hub
        Cost: $500-2,000/month FastConnect
        Use when: Hybrid cloud architecture
```

## Tagging Strategy

### Required Tags (Mandatory)
```yaml
Tag Namespace: Organization
Tags:
  - CostCenter: [Finance code for chargeback]
    Type: String
    Mandatory: Yes
    Default: None

  - Environment: [Dev | Test | Prod | Sandbox]
    Type: Enum
    Mandatory: Yes
    Default: None

  - Owner: [Email or team name]
    Type: String
    Mandatory: Yes
    Default: ${iam.principal.name}

  - DataClassification: [Public | Internal | Confidential | Restricted]
    Type: Enum
    Mandatory: Yes (for data resources)
    Default: Internal

  - BackupPolicy: [None | Bronze | Silver | Gold]
    Type: Enum
    Mandatory: Yes (for stateful resources)
    Default: Bronze
```

### Optional Tags (Recommended)
```yaml
  - Project: [Project or product name]
  - ExpiryDate: [Auto-cleanup date for sandbox]
  - Compliance: [PCI | HIPAA | SOC2]
  - ManagedBy: [Terraform | Manual | Ansible]
```

## Cost Allocation Patterns

### Budget Hierarchy
```
Tenancy Budget: $100,000/month
├─ Network: $10,000/month (fixed)
├─ Security: $5,000/month (fixed)
├─ Workloads: $75,000/month
│   ├─ App1-Dev: $5,000/month
│   ├─ App1-Test: $8,000/month
│   ├─ App1-Prod: $25,000/month
│   ├─ App2-Dev: $3,000/month
│   ├─ App2-Test: $4,000/month
│   └─ App2-Prod: $30,000/month
└─ Shared-Services: $10,000/month

Alerts:
- 50% threshold: Warning
- 80% threshold: Critical (page on-call)
- 100% threshold: Auto-stop dev/test resources
```

## Progressive Loading References

### OCI CLI for Landing Zones

**WHEN TO LOAD** [`landing-zone-cli.md`](references/landing-zone-cli.md):
- Creating compartment hierarchies
- Setting up Security Zones and Cloud Guard
- Configuring tag defaults and tag namespaces
- Implementing hub-spoke network topology
- Creating budgets and cost tracking

**Example**: Create compartment hierarchy
```bash
oci iam compartment create \
  --compartment-id $TENANCY_ID \
  --name "Workloads" \
  --description "Application workloads"
```

**Do NOT load** for:
- General OCI architecture concepts (covered in this skill)
- IAM policy syntax (covered in iam-identity-management skill)
- Network configuration (covered in networking-management skill)

## When to Use This Skill

- Initial OCI tenancy setup and foundation
- Migrating from AWS/Azure/GCP to OCI
- Designing multi-tenant or multi-environment architectures
- Implementing governance and cost controls
- Preparing for compliance audits (CIS, SOC2, ISO27001)
- Scaling from single app to enterprise platform
- Disaster recovery and multi-region planning
