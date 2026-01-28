---
name: OCI Networking Management
description: Use when designing OCI networks, troubleshooting connectivity, optimizing egress costs, or configuring VCN security. Covers Service Gateway cost savings, VCN CIDR immutability, Security List vs NSG tradeoffs, VCN peering limitations, and Load Balancer subnet requirements. Keywords: egress costs service gateway, VCN CIDR cannot change, security list limit 5, local peering same region, LB subnet too small.
version: 2.0.0
---

# OCI Networking - Expert Knowledge

You are an OCI networking expert. This skill provides knowledge Claude lacks: Service Gateway egress savings, VCN CIDR immutability, Security List limits, VCN peering gotchas, and OCI-specific networking anti-patterns.

## NEVER Do This

❌ **NEVER route Oracle service traffic via Internet Gateway (expensive)**
```
Service Gateway routing saves egress costs:

# WRONG - route Object Storage via Internet Gateway
Route: 0.0.0.0/0 → Internet Gateway
Cost: 10 TB to Object Storage = $85/month egress

# RIGHT - route Oracle services via Service Gateway
Route: <oci-services-cidr> → Service Gateway
Cost: 10 TB to Object Storage = $0 (FREE!)

Savings example (database backups to Object Storage):
- Without Service Gateway: 20 TB/month × $0.0085/GB = $170/month
- With Service Gateway: $0/month
- Annual savings: $2,040

Service Gateway supports:
✓ Object Storage (all tiers)
✓ Autonomous Database (for private endpoint ADB)
✓ Oracle Services Network (OSN)
```

**Critical**: Service Gateway egress is FREE, Internet Gateway egress is CHARGED

❌ **NEVER forget VCN CIDR cannot be changed (immutable)**
```
# WRONG - create VCN with /24, plan to expand later
oci network vcn create --cidr-block "10.0.0.0/24"
# Cannot expand to /16 later (OCI limitation!)

# If you run out of IPs:
1. Create new VCN with larger CIDR
2. Migrate all resources (hours of downtime)
3. Update DNS, security rules, route tables
4. Delete old VCN

Migration cost: Hours of downtime, IP address changes, extensive reconfiguration

# RIGHT - plan for growth from day 1
oci network vcn create --cidr-block "10.0.0.0/16"
# Room for 256 /24 subnets, 65,536 IPs total

Best practice: Use /16 for VCNs, /24 for subnets
```

❌ **NEVER exceed 5 Security Lists per subnet (hard limit)**
```
OCI limit: Maximum 5 security lists per subnet

# Problem: Complex app with many tiers
Subnet needs rules for:
- Web traffic (80, 443)
- SSH access
- Monitoring agents
- Database clients
- Logging services
... 10+ security lists needed? IMPOSSIBLE!

# WRONG - try to add 6th security list
oci network subnet update \
  --subnet-id <ocid> \
  --security-list-ids '["<sl1>","<sl2>","<sl3>","<sl4>","<sl5>","<sl6>"]'
# FAILS: "Maximum security lists (5) exceeded"

# RIGHT - use Network Security Groups (NSGs) instead
NSG limits:
- 5 NSGs per resource (same as security lists)
- 120 rules per NSG (vs unlimited in security lists)
- Unlimited NSGs per VCN

Migration strategy:
1. Security Lists: Baseline rules (internet, DNS, ICMP)
2. NSGs: Application-specific rules (app tier → DB tier)
```

**Best practice**: Security Lists for subnet-wide rules, NSGs for resource-specific rules

❌ **NEVER assume VCN peering supports transitive routing**
```
Scenario: VCN-A ↔ VCN-B ↔ VCN-C (peered)

# WRONG assumption: A can reach C via B
VCN-A instance: ping <VCN-C-instance>
# FAILS! Transitive routing NOT supported

# OCI VCN peering is NON-TRANSITIVE:
VCN-A can reach: VCN-B only
VCN-C can reach: VCN-B only
VCN-A CANNOT reach VCN-C

# RIGHT - explicit peering required
Create peering: VCN-A ↔ VCN-C
Now A can reach C directly

Peering types:
1. Local peering: Same region, FREE
2. Remote peering: Cross-region, requires DRG ($0.01/hr)

Cost impact (3-VCN mesh):
- Without transitive: 3 peerings (A-B, B-C, A-C)
- Remote peering: 3 × $7.30/month = $21.90/month
```

❌ **NEVER use /27 or smaller for Load Balancer subnets**
```
Load Balancer subnet requirements:
- Minimum /24 CIDR (256 IPs)
- 2 subnets in different ADs (for HA)
- Each subnet needs space for:
  * LB frontends (1-5 IPs)
  * LB backends (dynamic scaling)
  * Reserved IPs (5-10 per subnet)

# WRONG - /27 subnet for LB
oci network subnet create --cidr-block "10.0.1.0/27"
# Only 32 IPs total (27 usable after OCI reserves 5)
# LB creation FAILS: "Insufficient IP space"

# RIGHT - /24 minimum
oci network subnet create --cidr-block "10.0.1.0/24"
# 256 IPs, room for scaling

Gotcha: LB reserves IPs even when not scaling (future capacity)
```

❌ **NEVER delete default route table (breaks subnets)**
```
Every VCN has a default route table (auto-created):
- Cannot be deleted (while VCN exists)
- Can be modified

# WRONG - try to delete default route table
oci network route-table delete --rt-id <default-rt-ocid>
# FAILS: "Cannot delete default route table"

# Workaround: Create custom route tables for subnets
1. Create new route table
2. Associate subnet with new route table
3. Leave default route table unused (orphaned but exists)
```

❌ **NEVER assume Security Lists are stateless (they're stateful!)**
```
Common confusion: OCI Security Lists vs AWS Security Groups

OCI Security Lists: STATEFUL
- Ingress rule allows TCP 443 → auto-allows response traffic
- No need for explicit egress rule for responses

AWS Security Groups: Also STATEFUL (same behavior)
AWS Network ACLs: STATELESS (different, requires both directions)

# WRONG (from AWS NACL habit): Add both ingress and egress
Security List ingress: Allow TCP 443 from 0.0.0.0/0
Security List egress: Allow TCP 1024-65535 to 0.0.0.0/0  # Unnecessary!

# RIGHT - ingress rule only
Security List ingress: Allow TCP 443 from 0.0.0.0/0
# Response traffic auto-allowed (stateful)
```

## Networking Cost Optimization

### Service Gateway Savings

**Scenario: Database backups to Object Storage**

```
Monthly backup: 30 TB uploaded to Object Storage

Without Service Gateway (via Internet Gateway):
- Route: 0.0.0.0/0 → Internet Gateway
- Egress cost: 30,000 GB × $0.0085/GB = $255/month
- Ingress: FREE (always free in OCI)

With Service Gateway:
- Route: <oci-services-cidr> → Service Gateway
- Egress cost: $0 (FREE!)
- Ingress: FREE

Annual savings: $255 × 12 = $3,060/year
```

**Service Gateway routing example**:
```bash
# Get OCI Services CIDR for your region
oci network service list --all

# Create Service Gateway
oci network service-gateway create \
  --compartment-id <ocid> \
  --vcn-id <vcn-ocid> \
  --services '[{"serviceId":"<all-services-ocid>"}]' \
  --display-name "ServiceGateway"

# Add route in private subnet route table
# Destination: <oci-services-cidr> (e.g., all-phx-services-in-oracle-services-network)
# Target: Service Gateway OCID
```

### FastConnect vs VPN Cost Comparison

```
Scenario: Hybrid cloud connectivity, 500 GB/month data transfer

VPN (Site-to-Site):
- VPN tunnel: $0.05/hr × 730 hrs = $36.50/month
- Data processed: FREE (no per-GB charge)
- Egress: 500 GB × $0.0085/GB = $4.25/month
Total: $40.75/month

FastConnect (1 Gbps):
- Port: $1,100/month (flat rate)
- Data transfer: FREE (unlimited)
Total: $1,100/month

Breakeven: When egress > 126 GB/month, consider FastConnect
Or: When predictable latency required (FastConnect = 5-20ms, VPN = 30-50ms)

VPN use case: Dev/test, <100 GB/month
FastConnect use case: Production, >500 GB/month, low latency
```

## VCN Design Anti-Patterns

**Anti-pattern: Single subnet for all tiers**

```
# WRONG - web, app, DB in one subnet
Subnet: 10.0.1.0/24 (all resources)
Security: Broad security list (many open ports)
Risk: Lateral movement, no segmentation

# RIGHT - subnet per tier
Subnet 1: 10.0.1.0/24 (web tier, public)
Subnet 2: 10.0.2.0/24 (app tier, private)
Subnet 3: 10.0.3.0/24 (DB tier, private)

NSGs:
- Web NSG: Allow 80/443 from internet
- App NSG: Allow 8080 from Web NSG only
- DB NSG: Allow 1521 from App NSG only

Benefits:
✓ Blast radius containment
✓ Granular security
✓ Clear network segmentation
✓ Compliance (PCI-DSS, HIPAA)
```

**Anti-pattern: /28 subnets (too small)**

```
# WRONG - tiny subnets
VCN: 10.0.0.0/16
Subnets: /28 (16 IPs each, 11 usable after OCI reserves 5)

Problem: No room for scaling
- 10 instances = 10 IPs
- Add 2 more instances? No space!
- Must create new subnet, migrate resources

# RIGHT - adequate sizing
VCN: 10.0.0.0/16
Subnets: /24 (256 IPs each, 251 usable)

Sizing guide:
- Small app: /26 (64 IPs, 59 usable)
- Medium app: /24 (256 IPs, 251 usable)
- Large app: /23 (512 IPs, 507 usable)
- Load Balancer: /24 minimum (hard requirement)
```

## VCN Peering Gotchas

**Local Peering** (same region):
```
Cost: FREE
Latency: <1ms (same as within VCN)
Use case: Multi-VCN design (security boundaries)

Setup:
1. Create Local Peering Gateway (LPG) in each VCN
2. Connect LPGs (bidirectional)
3. Add routes in each VCN:
   VCN-A route: <VCN-B-CIDR> → LPG
   VCN-B route: <VCN-A-CIDR> → LPG

Limitation: Same region only (cannot peer Phoenix ↔ Ashburn)
```

**Remote Peering** (cross-region):
```
Cost: $0.01/hr per DRG connection = $7.30/month
Latency: Geography-dependent (Phoenix ↔ Ashburn = ~70ms)
Use case: Multi-region DR, global applications

Setup:
1. Create DRG in each region
2. Attach DRG to VCN (each region)
3. Create Remote Peering Connection (RPC) on each DRG
4. Connect RPCs (cross-region)
5. Add routes in each VCN

Cost example (3 regions interconnected):
- 3 DRG attachments: 3 × $7.30/month = $21.90/month
```

**Transitive routing NOT supported**:
```
VCN-A ↔ VCN-B ↔ On-Premises (via VPN)

# WRONG assumption: A can reach on-premises via B
VCN-A → VCN-B → On-Prem (FAILS!)

# RIGHT - hub-and-spoke with DRG
VCN-A → DRG ← On-Premises
VCN-B → DRG ← On-Premises

DRG acts as router (supports transitive)
All VCNs can reach on-premises
All VCNs can reach each other
```

## Security List vs NSG Decision Matrix

| Use Case | Use Security Lists | Use NSGs |
|----------|-------------------|----------|
| **Subnet-wide baseline** (DNS, NTP, ICMP) | ✓ | |
| **Internet egress** (all resources) | ✓ | |
| **Application tier isolation** (app → DB) | | ✓ |
| **Resource-specific rules** (this DB only) | | ✓ |
| **Complex app** (>5 security lists needed) | | ✓ |
| **Instance-level security** (per-instance rules) | | ✓ |

**Recommended pattern**:
```
1 Security List per subnet (baseline):
- Allow all egress
- Allow ICMP (ping)
- Allow DNS (UDP 53)
- Allow NTP (if needed)

Multiple NSGs per VCN (application):
- Web NSG: Allow 80/443 from internet
- App NSG: Allow 8080 from Web NSG
- DB NSG: Allow 1521 from App NSG
- Monitor NSG: Allow 9090 from management subnet

Assign:
- All instances: Security List (via subnet)
- Web instances: Web NSG
- App instances: App NSG
- DB instances: DB NSG + Monitor NSG
```

## When to Use This Skill

- Network design: VCN planning, subnet sizing, CIDR allocation
- Cost optimization: Service Gateway setup, FastConnect vs VPN
- Security: NSG vs Security List selection, network segmentation
- Troubleshooting: Connectivity issues, routing problems, peering
- High availability: Multi-AD subnet design, Load Balancer requirements
- Hybrid connectivity: VPN, FastConnect, DRG configuration
