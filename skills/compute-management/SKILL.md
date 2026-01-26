---
name: OCI Compute Management
description: Manage Oracle Cloud Infrastructure compute instances - launching, terminating, updating, monitoring, and troubleshooting VMs and bare metal instances
version: 1.0.0
---

# OCI Compute Management Skill

You are an expert in Oracle Cloud Infrastructure compute instance management. Use this skill when the user needs to work with compute instances, including VMs, bare metal servers, and instance configurations.

## Core Capabilities

### Instance Lifecycle Management
- **Launch instances**: Create new compute instances with proper shape, image, networking, and storage configuration
- **Terminate instances**: Safely shut down and remove instances
- **Instance actions**: Start, stop, reboot, and reset instances
- **Update instances**: Modify instance metadata, display name, and other properties

### Instance Discovery and Monitoring
- **List instances**: Find instances by compartment, state, availability domain, or tags
- **Get instance details**: Retrieve comprehensive information about specific instances
- **Monitor metrics**: Check CPU, memory, network, and disk utilization
- **Console access**: Establish serial console connections for troubleshooting

### Networking and Storage
- **VNIC management**: List and manage virtual network interface cards
- **Boot volumes**: Work with boot volume configurations and backups
- **Block volumes**: Attach and detach additional storage volumes
- **Private IPs**: Manage secondary private IP addresses

## OCI CLI Commands Reference

### Listing Instances
```bash
# List all instances in a compartment
oci compute instance list --compartment-id <compartment-ocid>

# List running instances only
oci compute instance list --compartment-id <compartment-ocid> --lifecycle-state RUNNING

# List instances in specific availability domain
oci compute instance list --compartment-id <compartment-ocid> --availability-domain <ad-name>
```

### Instance Details
```bash
# Get detailed information about an instance
oci compute instance get --instance-id <instance-ocid>

# Get VNIC attachments for an instance
oci compute vnic-attachment list --compartment-id <compartment-ocid> --instance-id <instance-ocid>

# Get console connection for troubleshooting
oci compute instance-console-connection list --compartment-id <compartment-ocid> --instance-id <instance-ocid>
```

### Instance Actions
```bash
# Launch a new instance
oci compute instance launch \
  --availability-domain <ad-name> \
  --compartment-id <compartment-ocid> \
  --shape <shape-name> \
  --subnet-id <subnet-ocid> \
  --image-id <image-ocid> \
  --display-name "MyInstance"

# Start a stopped instance
oci compute instance action --action START --instance-id <instance-ocid>

# Stop a running instance
oci compute instance action --action STOP --instance-id <instance-ocid>

# Reboot an instance
oci compute instance action --action REBOOT --instance-id <instance-ocid>

# Terminate an instance
oci compute instance terminate --instance-id <instance-ocid>
```

### Instance Configuration
```bash
# Update instance display name
oci compute instance update --instance-id <instance-ocid> --display-name "NewName"

# List available shapes
oci compute shape list --compartment-id <compartment-ocid>

# List available images
oci compute image list --compartment-id <compartment-ocid> --operating-system "Oracle Linux"
```

## Best Practices

### Instance Planning
1. **Choose appropriate shapes**: Match workload requirements to instance shapes (CPU, memory, network bandwidth)
2. **Select correct image**: Use official Oracle Linux, Ubuntu, or custom images
3. **Plan networking**: Ensure subnets, security lists, and NSGs are configured before launching
4. **Availability domains**: Distribute instances across ADs for high availability

### Security Considerations
1. **Use IAM policies**: Apply least-privilege access for instance management
2. **Security groups**: Configure network security groups (NSGs) for fine-grained control
3. **SSH key management**: Use strong SSH keys and rotate regularly
4. **Console access**: Only create console connections when necessary for troubleshooting

### Cost Optimization
1. **Right-sizing**: Choose shapes that match actual workload requirements
2. **Stop unused instances**: Stop instances during non-business hours if possible
3. **Use flexible shapes**: Leverage flexible VM shapes to adjust OCPUs and memory
4. **Monitor utilization**: Regularly review metrics to identify underutilized instances

### Operational Excellence
1. **Tagging strategy**: Apply consistent tags for cost tracking and organization
2. **Backup strategy**: Implement regular boot volume backups
3. **Monitoring**: Set up alarms for instance health and performance metrics
4. **Documentation**: Maintain clear documentation of instance purposes and configurations

## Common Workflows

### Creating a Web Server Instance
1. Identify the compartment and subnet for the instance
2. Select appropriate shape (e.g., VM.Standard.E4.Flex)
3. Choose Oracle Linux or Ubuntu image
4. Configure ingress rules for HTTP/HTTPS in security list or NSG
5. Launch instance with cloud-init script to install web server
6. Verify instance is running and accessible

### Troubleshooting Instance Issues
1. Check instance lifecycle state and any error messages
2. Review console history for boot/startup errors
3. Verify VNIC attachment and network configuration
4. Check security list and NSG rules
5. Establish serial console connection if needed
6. Review OCI monitoring metrics for resource bottlenecks

### Instance Migration
1. Create custom image from source instance
2. Launch new instance in target compartment/region using custom image
3. Verify application functionality
4. Update DNS or load balancer configuration
5. Terminate old instance after validation period

## Error Handling

Common errors and resolutions:

- **"Out of capacity"**: Try different availability domain or shape
- **"Authorization failed"**: Verify IAM policies grant necessary permissions
- **"Subnet not found"**: Ensure subnet exists and is in correct compartment
- **"Shape not available"**: Check service limits and shape availability in region
- **"Instance stuck in provisioning"**: Check console history for errors, may need to terminate and relaunch

## Integration with Other Skills

- **Networking**: Coordinate with VCN and subnet management for network setup
- **Monitoring**: Use monitoring skill to track instance health and performance
- **Database**: For database workloads, consider dedicated database services
- **Load Balancing**: Integrate instances with OCI load balancers for HA
- **Storage**: Work with block volume management for additional storage needs

## When to Use This Skill

Activate this skill when the user mentions:
- Creating, launching, or provisioning compute instances or VMs
- Starting, stopping, rebooting, or terminating instances
- Checking instance status, health, or details
- Troubleshooting instance connectivity or performance issues
- Managing instance networking (VNICs, IPs)
- Configuring or modifying instance properties
- Instance migration or scaling operations
- Compute shapes, images, or availability domains

## Example Interactions

**User**: "Launch a new web server instance in my production compartment"
**Response**: Use this skill to guide through shape selection, image choice, subnet configuration, and launch command execution.

**User**: "Why is my instance not responding?"
**Response**: Use this skill to systematically troubleshoot - check state, review console history, verify networking, and establish console connection if needed.

**User**: "List all running instances in us-phoenix-1"
**Response**: Use this skill to execute appropriate list command with lifecycle-state filter and present results clearly.
