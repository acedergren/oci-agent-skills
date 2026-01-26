---
name: OCI Best Practices and Architecture
description: Oracle Cloud Infrastructure best practices covering security, cost optimization, performance, operational excellence, and reliability. Based on official Oracle guidance and OCI Well-Architected Framework.
version: 1.0.0
---

# OCI Best Practices and Architecture Skill

You are an expert in Oracle Cloud Infrastructure best practices and well-architected framework principles. This skill provides official Oracle guidance for security, cost, performance, operations, and reliability based on https://www.oracle.com/cloud/oci-best-practices-guide/ and https://docs.oracle.com/solutions/.

## Core Best Practice Categories

1. **Security** - Zero trust, IAM, encryption, Cloud Guard
2. **Cost Optimization** - Right-sizing, reserved capacity, monitoring
3. **Performance** - Shape selection, caching, network optimization
4. **Operational Excellence** - IaC, monitoring, CI/CD, automation
5. **Reliability** - HA, DR, backups, multi-AD architecture

## Security Best Practices

### Zero Trust Architecture
- Never trust, always verify principle
- Implement identity domains with MFA
- Use microsegmentation with NSGs
- Encrypt all data at rest and in transit
- Enable Cloud Guard for threat detection

### CIS OCI Foundations Benchmark
```bash
# Deploy CIS-compliant landing zone
oci resource-manager stack create \
  --compartment-id <compartment-ocid> \
  --config-source <cis-template-zip> \
  --display-name "CIS-Landing-Zone"

# Key controls:
✓ Least privilege IAM policies
✓ MFA for all users
✓ Security zones enabled
✓ Encryption by default
✓ Audit logging active
✓ Network security groups
```

### Preventive Controls
- **OCI Network Firewall**: Perimeter protection with layer 7 inspection
- **Security Zones**: Enforce policies at infrastructure level
- **WAF**: Protect internet-facing applications from OWASP Top 10
- **DDoS Prevention**: Built-in layer 3/4/7 protection

### Detective Controls
- **Oracle Cloud Guard**: Continuous monitoring and automated response
- **Vulnerability Scanning**: Regular OS and app scanning
- **Data Safe**: Database security assessments and auditing
- **Logging Analytics**: Centralized log aggregation and analysis

## Cost Optimization

### Right-Sizing Strategy
```
Workload          | Start With        | Scale Based On
Development       | VM.Standard.E4.Flex (1 OCPU) | CPU >70%
Production        | VM.Standard.E4.Flex (2 OCPU) | Sustained metrics
Cost-optimized    | VM.Standard.A1.Flex (Arm)    | 40% savings
HPC/GPU           | BM.GPU4.8                    | Workload needs
```

### Free Tier Resources
```
Always Free (no time limit):
✓ 2 Autonomous Databases (1 OCPU each)
✓ 2 AMD Compute VMs (1/8 OCPU, 1GB)
✓ 4 Arm Ampere A1 cores (24GB total)
✓ 200GB Block Storage
✓ 10GB Object Storage + 10GB Archive
✓ Load Balancer (10 Mbps)

Strategy: Use for dev/test/POC
```

### Storage Tiering
```bash
# Lifecycle policy for automatic tiering
oci os object-lifecycle-policy put \
  --bucket-name <bucket> \
  --items '[{
    "name":"ArchiveOldLogs",
    "action":"ARCHIVE",
    "timeAmount":90,
    "timeUnit":"DAYS",
    "objectNameFilter":{"inclusionPrefixes":["logs/"]}
  }]'

# Cost comparison:
Standard Storage:    $0.0255/GB/month
Infrequent Access:   $0.0125/GB/month (51% savings)
Archive Storage:     $0.0024/GB/month (91% savings)
```

### Budget Monitoring
```bash
# Set budget with alerts
oci budgets budget create \
  --compartment-id <compartment-ocid> \
  --amount 1000 \
  --reset-period MONTHLY \
  --targets '["<compartment-ocid>"]' \
  --alert-rule-recipients '{"emailRecipients":["team@example.com"]}'

# Track costs by tags
Tags: Environment, CostCenter, Owner, Application
```

## Performance Excellence

### Compute Performance
```
Shape Selection Guide:
✓ VM.Standard.E4.Flex: General purpose, flexible
✓ VM.DenseIO.E4: High IOPS workloads
✓ BM.Standard.E4: Bare metal for maximum performance
✓ VM.GPU.A10: AI/ML inference
✓ BM.GPU.A100: Training large models

Start small, scale based on metrics (not guesses)
```

### Block Volume Performance
```bash
# Ultra High Performance volume
oci bv volume create \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad> \
  --size-in-gbs 1000 \
  --vpus-per-gb 20  # 255 IOPS/GB, 300K IOPS max

Performance Tiers:
Balanced:              60 IOPS/GB
Higher Performance:    75 IOPS/GB
Ultra High:            90-255 IOPS/GB
```

### Network Optimization
```
Best Practices:
✓ Regional subnets for flexibility
✓ Adequate CIDR space (/16 VCN, /24 subnets)
✓ FastConnect for predictable latency
✓ Place resources in same AD for <1ms latency
✓ Use flexible load balancers

Latency Guide:
Same AD:          <1ms
Different AD:     1-2ms
Cross-region:     Geography-dependent
FastConnect:      5-20ms (vs 30-50ms internet)
```

### Caching Strategies
```
Implementation:
✓ Redis/Memcached for session data
✓ Database query result caching
✓ CDN for static content
✓ Browser caching headers
✓ OCI Object Storage with CDN

Benefits: 10-100x faster, reduced DB load, lower costs
```

## Operational Excellence

### Infrastructure as Code
```hcl
# Terraform state in OCI Object Storage
terraform {
  backend "s3" {
    bucket   = "terraform-state"
    key      = "prod/terraform.tfstate"
    region   = "us-phoenix-1"
    endpoint = "https://namespace.compat.objectstorage.us-phoenix-1.oraclecloud.com"
    skip_region_validation = true
  }
}

Best Practices:
✓ Use modules for reusability
✓ Separate state files per environment
✓ Implement proper variable management
✓ Use Resource Manager for team collaboration
✓ Tag all resources consistently
```

### Tagging Strategy
```bash
# Comprehensive tagging
oci compute instance update \
  --instance-id <instance-ocid> \
  --defined-tags '{
    "Operations":{
      "Environment":"Production",
      "CostCenter":"ENG-001",
      "Owner":"platform-team",
      "Application":"web-app",
      "BackupPolicy":"daily",
      "Compliance":"PCI-DSS"
    }
  }'

Use tags for:
- Cost allocation and reporting
- Automated backup policies
- Resource grouping
- Compliance tracking
```

### Monitoring and Alarms
```bash
# Critical alarm (page immediately)
oci monitoring alarm create \
  --compartment-id <compartment-ocid> \
  --display-name "Database Critical CPU" \
  --namespace "oci_autonomous_database" \
  --query-text 'CpuUtilization[1m].mean() > 90' \
  --severity "CRITICAL" \
  --destinations '["<pager-topic-ocid>"]' \
  --pending-duration "PT5M" \
  --repeat-notification-duration "PT5M"

Monitoring Stack:
- Service logs → OCI Logging
- Application logs → Logging Analytics
- Metrics → OCI Monitoring
- APM → Application Performance Monitoring
```

### CI/CD Pipeline
```
DevSecOps Stages:
1. Code commit → Git webhook
2. Build → Compile and package
3. Security scan → SAST, dependency check
4. Unit tests → Code coverage
5. Container build → Docker image
6. Push to OCIR → Registry
7. Deploy to dev → Automated
8. Integration tests → Automated
9. Deploy to prod → Manual approval

Security Checkpoints:
✓ Static analysis
✓ Dependency scanning
✓ Container image scanning
✓ IAM policy validation
✓ Secrets detection
```

## Reliability and High Availability

### Multi-AD Architecture
```
Highly Available Pattern:

Region: us-phoenix-1

AD-1:                  AD-2:                  AD-3:
- Load Balancer       - Load Balancer        - Load Balancer
- Web tier (2)        - Web tier (2)         - Web tier (2)
- App tier (2)        - App tier (2)         - App tier (2)
- Database (primary)  - Database (standby)   - Database (standby)

Benefits:
✓ 99.99% availability SLA
✓ Automatic failover
✓ No single point of failure
✓ Performance optimization
```

### Database High Availability
```bash
# Autonomous Database (built-in HA)
✓ Automatic 3-way replication across ADs
✓ RPO ~0, RTO <2 minutes
✓ Automated backups with 60-day retention
✓ Point-in-time recovery

# Cross-region DR with Data Guard
oci db autonomous-database create-autonomous-database-dataguard-association \
  --autonomous-database-id <primary-adb-ocid> \
  --creation-type NEW \
  --peer-region <dr-region>

# DB System with RAC (2-node cluster)
oci db system launch \
  --shape "VM.Standard2.2" \
  --node-count 2 \
  --cluster-name "proddb" \
  --cpu-core-count 4
```

### Backup Strategy (3-2-1 Rule)
```
3 copies of data
2 different storage types
1 offsite (different region)

OCI Implementation:
✓ Primary: Production data (region A)
✓ Secondary: Boot volume backups (region A)
✓ Tertiary: Object storage replication (region B)

Retention Policy:
Daily:    7 days
Weekly:   4 weeks
Monthly:  12 months
Yearly:   7 years (compliance)
```

### Disaster Recovery
```
RTO/RPO by Business Tier:

Tier | RTO      | RPO      | Strategy
1    | <1 hour  | <15 min  | Active-active + Data Guard
2    | <4 hours | <1 hour  | Hot standby
3    | <24 hrs  | <4 hours | Warm standby
4    | <72 hrs  | <24 hrs  | Backup/restore

Implementation:
Tier 1: Multi-region, automatic failover
Tier 2: Standby region, manual failover
Tier 3: Regular backups, restore to new region
Tier 4: Archive storage, restore on demand
```

## Service-Specific Best Practices

### Generative AI on OCI
```
Model Selection:
✓ Cohere Command R+: Chat applications
✓ Cohere Command: Content generation
✓ CodeLlama: Code generation
✓ Cohere Embed v3: Semantic search

RAG (Retrieval Augmented Generation):
1. Generate embeddings from user query
2. Vector search in knowledge base
3. Retrieve relevant context
4. Augment prompt with context
5. Generate response with LLM

Benefits: Up-to-date info, reduced hallucinations

Cost Optimization:
✓ On-demand for development
✓ Dedicated endpoints for production
✓ Cache responses where appropriate
✓ Implement rate limiting
```

### Containers on OCI (OKE)
```bash
# Production cluster
oci ce cluster create \
  --compartment-id <compartment-ocid> \
  --name "prod-cluster" \
  --kubernetes-version "v1.28.2" \
  --service-lb-subnet-ids '["<lb-subnet-ocid>"]' \
  --is-kubernetes-dashboard-enabled false

Best Practices:
✓ Private subnets for worker nodes
✓ Public subnet for load balancers only
✓ Enable pod security policies
✓ Use Kubernetes secrets + OCI Vault
✓ Implement network policies
✓ Enable cluster autoscaling
✓ Separate node pools by workload type
```

### E-Business Suite on OCI
```
Migration Approach:
✓ Use EBS Cloud Manager for automation
✓ Lift-and-shift initially, optimize later
✓ Private subnets for app and database tiers
✓ Enable SSO with OCI IAM Identity Domains
✓ Implement DR with OCI native services

HA Architecture:
- Application: Multiple instances across ADs
- Database: RAC or Data Guard
- Load balancer: Traffic distribution
- File storage: FSS with replication
- Backups: Automated OCI services
```

## Well-Architected Framework Checklist

### Security
- [ ] IAM policies follow least privilege
- [ ] MFA enabled for all privileged users
- [ ] Zero trust principles implemented
- [ ] Cloud Guard enabled and monitored
- [ ] All data encrypted at rest
- [ ] TLS 1.2+ for data in transit
- [ ] Regular vulnerability scanning
- [ ] Security zones for critical workloads

### Cost Optimization
- [ ] Resources right-sized based on metrics
- [ ] Budget alerts configured
- [ ] Cost tracking tags applied
- [ ] Unused resources identified and removed
- [ ] Storage tiering policies in place
- [ ] Reserved capacity for predictable workloads
- [ ] Free tier utilized for dev/test

### Performance
- [ ] Appropriate shapes selected
- [ ] Caching implemented where beneficial
- [ ] Database auto-scaling enabled
- [ ] Network optimized (FastConnect if needed)
- [ ] Performance testing completed
- [ ] Bottlenecks identified and resolved

### Operational Excellence
- [ ] Infrastructure as code (Terraform)
- [ ] CI/CD pipeline implemented
- [ ] Comprehensive monitoring and alarms
- [ ] Logging and log analytics enabled
- [ ] Automated backups configured
- [ ] Runbooks documented
- [ ] Disaster recovery tested

### Reliability
- [ ] Multi-AD deployment for critical workloads
- [ ] Database HA (RAC or Data Guard)
- [ ] Load balancers with health checks
- [ ] Backup and restore tested
- [ ] DR plan documented and tested
- [ ] Chaos engineering practiced
- [ ] SLAs defined and monitored

## Reference Architectures

Based on https://docs.oracle.com/solutions/:

### Three-Tier Web Application
```
Internet → WAF → Load Balancer (public subnet)
           ↓
    Web Tier (private subnet, multi-AD)
           ↓
    App Tier (private subnet, multi-AD)
           ↓
    Database (private subnet, Data Guard)
```

### Hybrid Cloud with FastConnect
```
On-Premises Data Center
         ↓ (FastConnect)
    DRG (Dynamic Routing Gateway)
         ↓
    OCI VCN (hub-spoke topology)
    - Shared services VCN
    - Production VCN
    - Development VCN
```

### AI/ML Platform
```
Data Sources → Data Integration
               ↓
        Object Storage (raw data)
               ↓
        Data Science notebooks
               ↓
        Model training (GPU instances)
               ↓
        Model catalog → Inference endpoints
```

## When to Use This Skill

Activate when user asks about:
- Architecture design and recommendations
- Best practices for any OCI service
- Security hardening or compliance
- Cost optimization strategies
- Performance tuning
- High availability and disaster recovery
- Operational excellence
- Well-architected framework
- CIS benchmarks
- Service-specific guidance (GenAI, OKE, EBS)

## Example Interactions

**User**: "What are OCI security best practices?"
**Response**: Cover zero trust, IAM, Cloud Guard, encryption, CIS compliance with specific implementation examples.

**User**: "How do I optimize my OCI costs?"
**Response**: Explain right-sizing, reserved capacity, storage tiering, free tier, with CLI commands and cost comparisons.

**User**: "Design a highly available application"
**Response**: Multi-AD architecture with load balancer, compute distribution, database HA, and DR strategy.

**User**: "Best practices for GenAI on OCI?"
**Response**: Model selection, RAG implementation, cost optimization, dedicated vs on-demand endpoints.

## Official Resources

- OCI Best Practices Guide: https://www.oracle.com/cloud/oci-best-practices-guide/
- Oracle Solutions: https://docs.oracle.com/solutions/
- Architecture Center: https://www.oracle.com/cloud/architecture-center/
- CIS OCI Benchmark: https://www.cisecurity.org/benchmark/oracle_cloud
