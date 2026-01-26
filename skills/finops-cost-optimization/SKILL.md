---
name: OCI FinOps and Cost Optimization
description: Financial operations, cost intelligence, usage analytics, anomaly detection, and cost optimization strategies for Oracle Cloud Infrastructure. Leverages Cost and Usage Reports, Autonomous Database AI, and OCI monitoring for automated FinOps insights.
version: 1.0.0
---

# OCI FinOps and Cost Optimization Skill

You are an expert in Oracle Cloud Infrastructure financial operations (FinOps) and cost optimization. This skill provides comprehensive guidance for cost intelligence, usage analytics, anomaly detection, and optimization strategies.

## Core FinOps Capabilities

### Cost and Usage Reporting
- Automated cost report generation and analysis
- Usage pattern identification
- Cost allocation by compartment, tag, and service
- Trend analysis and forecasting

### Cost Intelligence
- Anomaly detection using Autonomous Database ML
- Automated insights generation
- Cost optimization recommendations
- Budget variance analysis

### Resource Optimization
- Right-sizing recommendations
- Idle resource identification
- Reserved capacity planning
- Committed use discounts analysis

## Cost and Usage Reports CLI Commands

### Configuring Cost Reports

```bash
# List usage statements
oci usage-api usage-statement list \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z"

# Get summarized usage
oci usage-api usage-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --granularity DAILY

# Get usage by service
oci usage-api usage-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --granularity DAILY \
  --group-by service

# Get usage by compartment
oci usage-api usage-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --granularity DAILY \
  --group-by compartmentName

# Get usage by tag
oci usage-api usage-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --granularity DAILY \
  --group-by-tag Environment
```

### Cost Analysis Queries

```bash
# Get cost by resource
oci usage-api cost-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --granularity MONTHLY

# Forecast future costs
oci usage-api forecast-cost \
  --tenant-id <tenancy-ocid> \
  --time-forecast-started "2025-02-01T00:00:00Z" \
  --time-forecast-ended "2025-02-28T23:59:59Z"

# Get service-specific costs
oci usage-api cost-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --filter "service,equals,'COMPUTE'"
```

## Budget Management

### Creating and Managing Budgets

```bash
# Create budget
oci budgets budget create \
  --compartment-id <compartment-ocid> \
  --amount 10000 \
  --reset-period MONTHLY \
  --target-type COMPARTMENT \
  --targets '["<compartment-ocid>"]' \
  --display-name "Engineering Department Budget"

# Create budget with alert
oci budgets budget create \
  --compartment-id <compartment-ocid> \
  --amount 5000 \
  --reset-period MONTHLY \
  --target-type COMPARTMENT \
  --targets '["<compartment-ocid>"]' \
  --display-name "Development Budget" \
  --freeform-tags '{"Department":"Engineering","Environment":"Development"}'

# List budgets
oci budgets budget list \
  --compartment-id <compartment-ocid>

# Get budget details
oci budgets budget get \
  --budget-id <budget-ocid>

# Update budget amount
oci budgets budget update \
  --budget-id <budget-ocid> \
  --amount 15000

# Delete budget
oci budgets budget delete \
  --budget-id <budget-ocid>
```

### Budget Alert Rules

```bash
# Create alert rule (80% threshold)
oci budgets alert-rule create \
  --budget-id <budget-ocid> \
  --type ACTUAL \
  --threshold 80 \
  --threshold-type PERCENTAGE \
  --recipients "email@example.com" \
  --display-name "80% Budget Alert"

# Create forecast alert
oci budgets alert-rule create \
  --budget-id <budget-ocid> \
  --type FORECAST \
  --threshold 100 \
  --threshold-type PERCENTAGE \
  --recipients "email@example.com" \
  --display-name "Forecast 100% Alert"

# List alert rules
oci budgets alert-rule list \
  --budget-id <budget-ocid>

# Update alert rule
oci budgets alert-rule update \
  --budget-id <budget-ocid> \
  --alert-rule-id <alert-rule-ocid> \
  --threshold 90

# Delete alert rule
oci budgets alert-rule delete \
  --budget-id <budget-ocid> \
  --alert-rule-id <alert-rule-ocid>
```

## Cost Optimization Strategies

### Compute Optimization

```bash
# Find stopped instances (candidates for termination)
oci compute instance list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state STOPPED \
  --query 'data[*].{Name:"display-name",OCID:id,Shape:shape}'

# Find instances with low CPU utilization
# Use monitoring queries to identify underutilized resources
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace oci_computeagent \
  --query-text 'CpuUtilization[1d]{resourceId = "<instance-ocid>"}.mean()' \
  --start-time "2025-01-01T00:00:00Z" \
  --end-time "2025-01-31T23:59:59Z"

# Check for instances without activity
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace oci_computeagent \
  --query-text 'NetworkBytesOut[7d]{}.sum() < 1000000' \
  --start-time "2025-01-20T00:00:00Z" \
  --end-time "2025-01-27T23:59:59Z"
```

### Storage Optimization

```bash
# List unattached boot volumes (candidates for deletion)
oci bv boot-volume list \
  --compartment-id <compartment-ocid> \
  --availability-domain <ad-name> \
  --lifecycle-state AVAILABLE \
  --query 'data[?!"boot-volume-attachments"]|[*].{Name:"display-name",Size:"size-in-gbs",Created:"time-created"}'

# List unattached block volumes
oci bv volume list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state AVAILABLE

# Find old volume backups
oci bv backup list \
  --compartment-id <compartment-ocid> \
  --query 'data[?!"time-created" < `2024-01-01`]|[*].{Name:"display-name",Size:"size-in-gbs",Created:"time-created"}'

# Identify Object Storage buckets with lifecycle policies
oci os bucket list \
  --compartment-id <compartment-ocid> \
  --fields approximateCount,approximateSize

# Get Object Storage usage by bucket
oci os bucket get \
  --bucket-name <bucket-name> \
  --fields approximateCount,approximateSize
```

### Database Optimization

```bash
# Find stopped Autonomous Databases
oci db autonomous-database list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state STOPPED

# Check auto-scaling configuration
oci db autonomous-database list \
  --compartment-id <compartment-ocid> \
  --query 'data[*].{Name:"display-name",AutoScaling:"is-auto-scaling-enabled",CPUs:"cpu-core-count"}'

# Identify databases without recent backups
oci db autonomous-database-backup list \
  --autonomous-database-id <adb-ocid> \
  --query 'data[?!"time-ended" < `2025-01-01`]'
```

## Anomaly Detection with Autonomous Database

### Setting Up Cost Anomaly Detection

Based on Oracle A-Team Chronicles article series "From Cost Reports to Cost Intelligence":

**Part 1: Data Ingestion**
1. Configure Cost and Usage Reports to Object Storage
2. Create Autonomous Database for analysis
3. Set up external tables pointing to cost reports
4. Schedule regular data refresh

**Part 2: ML Model Training**
```sql
-- Create ML model for anomaly detection
BEGIN
  DBMS_DATA_MINING.CREATE_MODEL2(
    model_name => 'COST_ANOMALY_MODEL',
    mining_function => 'CLASSIFICATION',
    data_query => 'SELECT * FROM cost_usage_data',
    set_list => 'ALGO_NAME=ALGO_AI',
    model_detail_level => 'FULL'
  );
END;
/

-- Apply model to detect anomalies
SELECT
  service_name,
  cost_date,
  actual_cost,
  predicted_cost,
  CASE WHEN ABS(actual_cost - predicted_cost) > (2 * STDDEV_POP(actual_cost) OVER ())
    THEN 'ANOMALY'
    ELSE 'NORMAL'
  END as status
FROM cost_predictions
ORDER BY cost_date DESC;
```

**Part 3: Automated Insights**
- Generate daily cost summaries
- Identify unusual spending patterns
- Create actionable recommendations
- Send alerts via OCI Notifications

**Part 4: Visualization and Reporting**
- Build OAC dashboards
- Create executive summaries
- Track optimization metrics
- Monitor budget adherence

**Part 5: Continuous Optimization**
- Implement feedback loops
- Refine ML models
- Automate remediation actions
- Track ROI of optimizations

## Pricing Intelligence

### Using OCI Pricing MCP Server

The `oracle-oci-pricing` MCP server provides real-time pricing data:

```bash
# Example queries (via MCP client):
# "What's the price for compute instance VM.Standard.E4.Flex in USD?"
# "Show Object Storage pricing in JPY"
# "Get pricing for SKU B93113"
# "List all Autonomous Database pricing"
```

**Key Features:**
- SKU-based pricing lookup
- Fuzzy product name search
- Multi-currency support
- Free-tier identification

### Cost Estimation

```bash
# Estimate compute costs
# Shape: VM.Standard.E4.Flex, 2 OCPUs, 16GB RAM
# Running 24/7 for 30 days
# Price: $0.02 per OCPU-hour + $0.0015 per GB-hour
# Monthly cost: 2 * 0.02 * 24 * 30 + 16 * 0.0015 * 24 * 30 = $46.08

# Estimate storage costs
# Block Volume: 1TB (1024GB)
# Price: $0.025 per GB-month
# Monthly cost: 1024 * 0.025 = $25.60

# Estimate Object Storage costs
# Standard tier: 500GB stored
# Price: $0.0255 per GB-month
# Monthly cost: 500 * 0.0255 = $12.75
```

## Resource Tagging for Cost Allocation

### Tag-Based Cost Tracking

```bash
# Create tag namespace
oci iam tag-namespace create \
  --compartment-id <tenancy-ocid> \
  --name "CostCenter" \
  --description "Cost center allocation tags"

# Create tag key
oci iam tag create \
  --tag-namespace-id <namespace-ocid> \
  --name "Department" \
  --description "Department name"

# Apply tags to resources
oci compute instance update \
  --instance-id <instance-ocid> \
  --defined-tags '{"CostCenter":{"Department":"Engineering","Project":"CloudMigration"}}'

# Query costs by tag
oci usage-api usage-summary list-usage \
  --tenant-id <tenancy-ocid> \
  --time-usage-started "2025-01-01T00:00:00Z" \
  --time-usage-ended "2025-01-31T23:59:59Z" \
  --group-by-tag "CostCenter.Department"
```

## Reserved Capacity and Commitments

### Universal Credits

```bash
# View subscription details
oci usage-api subscription list \
  --compartment-id <tenancy-ocid>

# View subscription rewards
oci usage-api reward list \
  --subscription-id <subscription-ocid> \
  --tenancy-id <tenancy-ocid>

# Check commitment status
oci usage-api subscription get \
  --subscription-id <subscription-ocid> \
  --tenancy-id <tenancy-ocid>
```

## Best Practices

### Cost Optimization
1. **Right-size resources**: Start small, scale based on actual usage
2. **Use auto-scaling**: Leverage ADB and compute auto-scaling
3. **Stop idle resources**: Automate shutdown of dev/test environments
4. **Leverage free tier**: Use always-free services for non-critical workloads
5. **Reserved capacity**: Commit to reserved instances for predictable workloads
6. **Storage tiering**: Move infrequently accessed data to Archive Storage

### FinOps Automation
1. **Daily cost reviews**: Automate daily cost report generation
2. **Anomaly alerts**: Set up ML-based anomaly detection
3. **Budget enforcement**: Configure budgets with automatic alerts
4. **Tagging standards**: Enforce consistent tagging for cost allocation
5. **Showback/chargeback**: Implement departmental cost allocation
6. **Optimization tracking**: Measure and report on savings realized

### Monitoring and Alerts
1. **Budget alerts**: Set multiple threshold alerts (50%, 80%, 100%)
2. **Usage spikes**: Monitor for unexpected usage increases
3. **Idle resources**: Regular scans for unused resources
4. **Cost trends**: Track month-over-month and year-over-year trends
5. **Service-specific**: Monitor high-cost services individually

## Common FinOps Workflows

### Monthly Cost Review
1. Generate cost report for previous month
2. Compare to budget and forecast
3. Identify anomalies and investigate root causes
4. Review top spending services and compartments
5. Identify optimization opportunities
6. Update forecasts based on trends

### Quarterly Optimization Review
1. Analyze 90-day cost trends
2. Review all stopped/idle resources
3. Evaluate reserved capacity needs
4. Assess storage lifecycle policies
5. Review and update budgets
6. Calculate realized savings from optimizations

### Annual Planning
1. Review full year spending patterns
2. Identify growth trends by service
3. Plan reserved capacity purchases
4. Set annual budgets by department
5. Define FinOps goals and KPIs
6. Establish cost optimization roadmap

## Integration with Other Services

### Cloud Guard Integration
- Cost-related security issues
- Overprivileged resources
- Publicly accessible expensive services

### Logging and Events
- Cost anomaly events
- Budget threshold breaches
- Resource lifecycle changes

### Notifications
- Email alerts for budget thresholds
- Slack/Teams integration for anomalies
- PagerDuty for critical cost events

## MCP Server Tools (Optional)

This skill provides full functionality using OCI CLI commands. Optional MCP servers enhance capabilities with real-time data:

1. **oracle-oci-usage**: Automated cost and usage data retrieval (vs CLI queries)
2. **oracle-oci-pricing**: Real-time pricing lookups (vs manual calculations)
3. **oracle-oci-resource-search**: Fast cross-compartment search (vs sequential queries)
4. **oracle-oci-cloud-guard**: Automated security recommendations (vs manual review)

**Note**: These servers require local installation. See [MCP Setup Guide](../../docs/MCP_SETUP.md). All functionality works without them using standard OCI CLI commands.

## When to Use This Skill

Activate this skill when the user mentions:
- Cost optimization, savings, or reduction
- Budget management or alerts
- Usage analysis or reporting
- FinOps, financial operations, or cost intelligence
- Anomaly detection in spending
- Reserved capacity or commitments
- Cost allocation or showback/chargeback
- Right-sizing resources
- Idle or unused resources
- Pricing information or estimates
- Cost forecasting or trends
- Tagging for cost tracking

## Example Interactions

**User**: "Show me my top 10 spending services this month"
**Response**: Use usage-api to query costs grouped by service, sorted by amount.

**User**: "Find idle compute instances to reduce costs"
**Response**: Query for stopped instances and check CPU utilization metrics for running instances.

**User**: "Set up anomaly detection for my OCI costs"
**Response**: Guide through setting up ADB with ML models for cost anomaly detection.

**User**: "What's the pricing for a VM.Standard.E4.Flex instance?"
**Response**: Use oracle-oci-pricing MCP server to fetch real-time pricing.
