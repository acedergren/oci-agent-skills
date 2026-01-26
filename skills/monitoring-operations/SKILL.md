---
name: OCI Monitoring and Observability
description: Monitor Oracle Cloud Infrastructure resources using metrics, alarms, logs, and events. Track compute, database, networking, and application performance.
version: 1.0.0
---

# OCI Monitoring and Observability Skill

You are an expert in Oracle Cloud Infrastructure monitoring, logging, and observability. This skill provides comprehensive CLI commands for metrics, alarms, logs, and events to compensate for Claude's limited OCI training data.

## Core Monitoring Services

### Monitoring Service
- Query metrics for all OCI resources
- Create and manage alarms
- Set up notifications for critical events
- Track resource utilization and performance

### Logging Service
- Centralized log collection and analysis
- Service logs, custom logs, and audit logs
- Log search and filtering
- Log retention and archival

### Events Service
- Track resource lifecycle changes
- Trigger actions based on events
- Integration with Functions, Notifications, Streaming

## Monitoring CLI Commands

### Querying Metrics
```bash
# List metric namespaces (to see what's available)
oci monitoring metric list-metrics \
  --compartment-id <compartment-ocid>

# Query compute instance CPU utilization
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace "oci_computeagent" \
  --query-text 'CpuUtilization[1m]{resourceId = "<instance-ocid>"}.mean()' \
  --start-time "2024-01-26T00:00:00Z" \
  --end-time "2024-01-26T23:59:59Z"

# Query database CPU metrics
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace "oci_autonomous_database" \
  --query-text 'CpuUtilization[5m]{resourceId = "<adb-ocid>"}.mean()' \
  --start-time "2024-01-26T00:00:00Z" \
  --end-time "2024-01-26T23:59:59Z"

# Query memory utilization
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace "oci_computeagent" \
  --query-text 'MemoryUtilization[1m]{resourceId = "<instance-ocid>"}.mean()' \
  --start-time "2024-01-26T00:00:00Z" \
  --end-time "2024-01-26T23:59:59Z"

# Query network bytes received
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace "oci_computeagent" \
  --query-text 'NetworksBytesIn[1m]{resourceId = "<instance-ocid>"}.sum()' \
  --start-time "2024-01-26T00:00:00Z" \
  --end-time "2024-01-26T23:59:59Z"

# Query load balancer metrics
oci monitoring metric-data summarize-metrics-data \
  --compartment-id <compartment-ocid> \
  --namespace "oci_lbaas" \
  --query-text 'HttpRequests[1m]{resourceId = "<lb-ocid>"}.sum()' \
  --start-time "2024-01-26T00:00:00Z" \
  --end-time "2024-01-26T23:59:59Z"
```

### Common Metric Namespaces and Metrics

**Compute (oci_computeagent)**:
- `CpuUtilization` - CPU usage percentage
- `MemoryUtilization` - Memory usage percentage
- `DiskBytesRead` - Disk read throughput
- `DiskBytesWritten` - Disk write throughput
- `NetworksBytesIn` - Network inbound bytes
- `NetworksBytesOut` - Network outbound bytes

**Autonomous Database (oci_autonomous_database)**:
- `CpuUtilization` - CPU usage percentage
- `StorageUtilization` - Storage used
- `Sessions` - Active sessions
- `ExecuteCount` - SQL executions per second

**Block Volume (oci_blockstore)**:
- `VolumeReadThroughput` - Read throughput
- `VolumeWriteThroughput` - Write throughput
- `VolumeReadOps` - Read IOPS
- `VolumeWriteOps` - Write IOPS

**Load Balancer (oci_lbaas)**:
- `HttpRequests` - HTTP requests per second
- `ActiveConnections` - Active connections
- `BytesReceived` - Bytes received
- `BytesSent` - Bytes sent

### Alarm Management
```bash
# List all alarms in compartment
oci monitoring alarm list \
  --compartment-id <compartment-ocid>

# Get alarm details
oci monitoring alarm get \
  --alarm-id <alarm-ocid>

# Create alarm for high CPU utilization
oci monitoring alarm create \
  --compartment-id <compartment-ocid> \
  --display-name "High CPU Alert" \
  --destinations '["<topic-ocid>"]' \
  --is-enabled true \
  --metric-compartment-id <compartment-ocid> \
  --namespace "oci_computeagent" \
  --query-text 'CpuUtilization[1m]{resourceId = "<instance-ocid>"}.mean() > 80' \
  --severity "CRITICAL" \
  --body "Instance CPU utilization exceeded 80%" \
  --pending-duration "PT5M" \
  --repeat-notification-duration "PT1H"

# Create alarm for database sessions
oci monitoring alarm create \
  --compartment-id <compartment-ocid> \
  --display-name "High DB Sessions" \
  --destinations '["<topic-ocid>"]' \
  --is-enabled true \
  --metric-compartment-id <compartment-ocid> \
  --namespace "oci_autonomous_database" \
  --query-text 'Sessions[1m]{resourceId = "<adb-ocid>"}.mean() > 100' \
  --severity "WARNING" \
  --body "Database sessions exceeded 100"

# Create alarm for disk space
oci monitoring alarm create \
  --compartment-id <compartment-ocid> \
  --display-name "Low Disk Space" \
  --destinations '["<topic-ocid>"]' \
  --is-enabled true \
  --metric-compartment-id <compartment-ocid> \
  --namespace "oci_computeagent" \
  --query-text 'DiskUtilization[1m]{resourceId = "<instance-ocid>"}.mean() > 85' \
  --severity "CRITICAL" \
  --body "Disk utilization exceeded 85%"

# Update alarm
oci monitoring alarm update \
  --alarm-id <alarm-ocid> \
  --is-enabled false

# Delete alarm
oci monitoring alarm delete \
  --alarm-id <alarm-ocid>

# Get alarm history
oci monitoring alarm-history-collection get-alarm-history \
  --alarm-id <alarm-ocid>

# Get alarm status
oci monitoring alarm-status get-alarm-status \
  --alarm-id <alarm-ocid>
```

## Logging CLI Commands

### Log Groups and Logs
```bash
# List log groups
oci logging log-group list \
  --compartment-id <compartment-ocid>

# Get log group details
oci logging log-group get \
  --log-group-id <log-group-ocid>

# Create log group
oci logging log-group create \
  --compartment-id <compartment-ocid> \
  --display-name "ApplicationLogs"

# List logs in log group
oci logging log list \
  --log-group-id <log-group-ocid>

# Get log details
oci logging log get \
  --log-group-id <log-group-ocid> \
  --log-id <log-ocid>

# Enable service log (e.g., VCN flow logs)
oci logging log create \
  --log-group-id <log-group-ocid> \
  --display-name "VCN Flow Logs" \
  --log-type SERVICE \
  --configuration '{
    "source": {
      "sourceType": "OCISERVICE",
      "service": "flowlogs",
      "resource": "<subnet-ocid>",
      "category": "all"
    },
    "compartmentId": "<compartment-ocid>"
  }' \
  --is-enabled true
```

### Searching Logs
```bash
# Search logs with time range
oci logging-search search-logs \
  --search-query "search \"<compartment-ocid>/<log-group-ocid>/<log-ocid>\" | source='<log-source>'" \
  --time-start "2024-01-26T00:00:00Z" \
  --time-end "2024-01-26T23:59:59Z"

# Search for specific pattern in logs
oci logging-search search-logs \
  --search-query "search \"<compartment-ocid>/<log-group-ocid>/<log-ocid>\" | source='<log-source>' | grep 'ERROR'" \
  --time-start "2024-01-26T00:00:00Z" \
  --time-end "2024-01-26T23:59:59Z"

# Search across multiple logs
oci logging-search search-logs \
  --search-query "search \"<compartment-ocid>/<log-group-ocid>/*\" | source='<log-source>'" \
  --time-start "2024-01-26T00:00:00Z" \
  --time-end "2024-01-26T23:59:59Z"

# Get recent log events (paginated)
oci logging-search search-logs \
  --search-query "search \"<compartment-ocid>/<log-group-ocid>/<log-ocid>\"" \
  --time-start "2024-01-26T00:00:00Z" \
  --time-end "2024-01-26T23:59:59Z" \
  --limit 100
```

### Log Types to Enable

**VCN Flow Logs**:
- Service: `flowlogs`
- Resource: Subnet OCID
- Category: `all`

**Load Balancer Access Logs**:
- Service: `loadbalancer`
- Resource: Load Balancer OCID
- Category: `access`

**Load Balancer Error Logs**:
- Service: `loadbalancer`
- Resource: Load Balancer OCID
- Category: `error`

**Object Storage Access Logs**:
- Service: `objectstorage`
- Resource: Bucket name
- Category: `write` or `read`

**Audit Logs** (automatically enabled):
- Service: `audit`
- All API calls logged

## Events Service CLI Commands

### Event Rules
```bash
# List event rules
oci events rule list \
  --compartment-id <compartment-ocid>

# Get event rule details
oci events rule get \
  --rule-id <rule-ocid>

# Create event rule for instance state changes
oci events rule create \
  --compartment-id <compartment-ocid> \
  --display-name "Instance State Changes" \
  --is-enabled true \
  --condition '{
    "eventType": ["com.oraclecloud.computeapi.terminateinstance.begin",
                  "com.oraclecloud.computeapi.launchinstance.end"]
  }' \
  --actions '{
    "actions": [{
      "actionType": "ONS",
      "isEnabled": true,
      "topicId": "<topic-ocid>"
    }]
  }'

# Create event rule for database changes
oci events rule create \
  --compartment-id <compartment-ocid> \
  --display-name "Database Events" \
  --is-enabled true \
  --condition '{
    "eventType": ["com.oraclecloud.databaseservice.autonomous.database.critical"]
  }' \
  --actions '{
    "actions": [{
      "actionType": "ONS",
      "isEnabled": true,
      "topicId": "<topic-ocid>"
    }]
  }'

# Create event rule triggering function
oci events rule create \
  --compartment-id <compartment-ocid> \
  --display-name "Trigger Function on Object Upload" \
  --is-enabled true \
  --condition '{
    "eventType": ["com.oraclecloud.objectstorage.createobject"]
  }' \
  --actions '{
    "actions": [{
      "actionType": "FAAS",
      "isEnabled": true,
      "functionId": "<function-ocid>"
    }]
  }'

# Update event rule
oci events rule update \
  --rule-id <rule-ocid> \
  --is-enabled false

# Delete event rule
oci events rule delete \
  --rule-id <rule-ocid>
```

### Common Event Types

**Compute Events**:
- `com.oraclecloud.computeapi.launchinstance.end`
- `com.oraclecloud.computeapi.terminateinstance.begin`
- `com.oraclecloud.computeapi.instanceaction.end`

**Database Events**:
- `com.oraclecloud.databaseservice.autonomous.database.critical`
- `com.oraclecloud.databaseservice.createautonomousdatabase.end`
- `com.oraclecloud.databaseservice.deleteautonomousdatabase.end`

**Networking Events**:
- `com.oraclecloud.virtualnetwork.createvcn.end`
- `com.oraclecloud.virtualnetwork.deletevcn.begin`

**Object Storage Events**:
- `com.oraclecloud.objectstorage.createobject`
- `com.oraclecloud.objectstorage.deleteobject`
- `com.oraclecloud.objectstorage.updateobject`

## Notifications Service

### Managing Topics and Subscriptions
```bash
# List notification topics
oci ons topic list \
  --compartment-id <compartment-ocid>

# Create notification topic
oci ons topic create \
  --compartment-id <compartment-ocid> \
  --name "AlertTopic"

# Get topic details
oci ons topic get \
  --topic-id <topic-ocid>

# List subscriptions for topic
oci ons subscription list \
  --compartment-id <compartment-ocid> \
  --topic-id <topic-ocid>

# Create email subscription
oci ons subscription create \
  --compartment-id <compartment-ocid> \
  --topic-id <topic-ocid> \
  --protocol EMAIL \
  --subscription-endpoint "user@example.com"

# Create SMS subscription
oci ons subscription create \
  --compartment-id <compartment-ocid> \
  --topic-id <topic-ocid> \
  --protocol SMS \
  --subscription-endpoint "+1234567890"

# Create Slack webhook subscription
oci ons subscription create \
  --compartment-id <compartment-ocid> \
  --topic-id <topic-ocid> \
  --protocol SLACK \
  --subscription-endpoint "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"

# Delete subscription
oci ons subscription delete \
  --subscription-id <subscription-ocid>

# Publish message to topic (for testing)
oci ons message publish \
  --topic-id <topic-ocid> \
  --title "Test Message" \
  --body "This is a test notification"
```

## Best Practices

### Metrics and Monitoring
1. **Baseline establishment**: Monitor for 1-2 weeks to establish normal patterns
2. **Appropriate intervals**: Use 1m for critical resources, 5m for less critical
3. **Aggregation functions**: Choose mean(), max(), min(), sum() based on metric type
4. **Retention awareness**: Metrics retained for 90 days, plan accordingly

### Alarm Configuration
1. **Critical vs warning**: Use CRITICAL for immediate action items, WARNING for awareness
2. **Pending duration**: Set 5-10 minutes to avoid false positives from spikes
3. **Repeat notifications**: Configure hourly or daily based on severity
4. **Multiple thresholds**: Create separate alarms for different severity levels
5. **Test alarms**: Verify notifications reach correct recipients

### Logging Strategy
1. **Log retention**: Set based on compliance requirements (default 30 days)
2. **Cost management**: Enable only necessary logs, storage costs can accumulate
3. **Search optimization**: Use specific time ranges and filters for faster searches
4. **Log analysis**: Export to OCI Data Science or external tools for deep analysis
5. **Security**: Enable audit logs for compliance and security monitoring

### Event Rules
1. **Specific event types**: Filter to only events you care about
2. **Compartment scope**: Apply rules at appropriate compartment level
3. **Action types**: Use ONS for notifications, FAAS for automation
4. **Testing**: Test event rules with actual resource changes
5. **Documentation**: Document what each rule does and why it exists

## Common Monitoring Workflows

### Setting Up Comprehensive Instance Monitoring
1. Create notification topic for alerts
2. Add email/SMS subscriptions
3. Create alarms:
   - CPU > 80% for 5 minutes (CRITICAL)
   - Memory > 85% for 5 minutes (CRITICAL)
   - Disk > 85% (WARNING)
   - Network errors (CRITICAL)
4. Enable VCN flow logs for troubleshooting
5. Create event rules for instance lifecycle changes
6. Test notifications

### Database Performance Monitoring
1. Set up alarms for:
   - CPU utilization > 80%
   - Storage utilization > 85%
   - Sessions > threshold
   - Query response time degradation
2. Enable database service logs
3. Create dashboard with key metrics
4. Set up weekly performance reports

### Cost Monitoring
1. Enable cost tracking tags on resources
2. Create alarms for budget thresholds
3. Monitor compute and storage utilization
4. Set up cost anomaly detection
5. Review monthly spending trends

## Troubleshooting

### Metrics Not Appearing
- Verify metric agent is running on compute instance
- Check IAM policies allow metrics posting
- Ensure resource is in correct compartment
- Wait 5-10 minutes for initial metrics to appear

### Alarm Not Triggering
- Verify alarm is enabled
- Check query syntax is correct
- Confirm pending duration hasn't expired
- Verify notification topic has subscriptions
- Check subscription endpoint is confirmed (email)

### Logs Not Showing
- Ensure log is enabled
- Verify IAM policies allow log writing
- Check log configuration is correct
- Wait a few minutes for logs to appear
- Verify time range in search query

### Notification Not Received
- Check subscription is confirmed (email requires confirmation)
- Verify subscription endpoint is correct
- Check spam/junk folder for emails
- Test with manual message publish
- Verify notification topic OCID in alarm

## Integration with Other Skills

- **Compute**: Monitor instance CPU, memory, disk, network metrics
- **Database**: Track database performance, sessions, storage
- **Networking**: VCN flow logs for traffic analysis
- **Storage**: Block volume and object storage metrics

## When to Use This Skill

Activate this skill when the user mentions:
- Monitoring resource metrics or performance
- Creating or configuring alarms
- Setting up notifications or alerts
- Querying logs or searching log data
- Enabling service logs (flow logs, access logs)
- Event rules or event-driven automation
- Performance troubleshooting
- Notification topics or subscriptions
- CPU, memory, disk, or network utilization
- Database metrics or sessions
- Alert thresholds or alarm conditions

## Example Interactions

**User**: "Show me CPU usage for my instance over the last hour"
**Response**: Use this skill to construct and execute the appropriate `oci monitoring metric-data summarize-metrics-data` command.

**User**: "Alert me when database CPU goes above 80%"
**Response**: Use this skill to create notification topic, subscription, and alarm with proper threshold configuration.

**User**: "Why didn't my alarm trigger?"
**Response**: Use this skill to troubleshoot alarm configuration, query syntax, and notification setup.

**User**: "I need to see VCN flow logs for debugging connectivity"
**Response**: Use this skill to enable flow logs on subnet and show how to search them.
