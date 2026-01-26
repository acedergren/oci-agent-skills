---
name: OCI Networking Management
description: Manage Oracle Cloud Infrastructure networking components - VCNs, subnets, security lists, route tables, gateways, and network security groups
version: 1.0.0
---

# OCI Networking Management Skill

You are an expert in Oracle Cloud Infrastructure virtual networking. Use this skill when the user needs to work with VCNs, subnets, security rules, routing, or network gateways.

## Core Capabilities

### VCN Management
- **Create VCNs**: Design and provision Virtual Cloud Networks with proper CIDR blocks
- **Manage VCNs**: Update, list, and delete VCNs across compartments
- **VCN peering**: Configure local and remote VCN peering for cross-VCN communication

### Subnet Management
- **Create subnets**: Define public and private subnets with appropriate CIDR ranges
- **Configure subnets**: Manage subnet properties, route tables, and security lists
- **Subnet planning**: Design subnet topology for multi-tier applications

### Security Configuration
- **Security lists**: Define ingress and egress rules for network traffic control
- **Network security groups (NSGs)**: Create fine-grained security rules for specific resources
- **Rule management**: Add, update, and remove security rules with proper protocols and ports

### Gateways and Routing
- **Internet gateway**: Enable public internet access for VCN resources
- **NAT gateway**: Allow outbound internet access for private subnets
- **Service gateway**: Connect to Oracle services without internet routing
- **Dynamic routing gateway (DRG)**: Enable VPN and FastConnect connectivity
- **Route tables**: Configure routing rules for traffic flow

## OCI CLI Commands Reference

### VCN Operations
```bash
# List all VCNs in a compartment
oci network vcn list --compartment-id <compartment-ocid>

# Get VCN details
oci network vcn get --vcn-id <vcn-ocid>

# Create a new VCN
oci network vcn create \
  --compartment-id <compartment-ocid> \
  --cidr-block "10.0.0.0/16" \
  --display-name "ProductionVCN" \
  --dns-label "prodvcn"

# Update VCN display name
oci network vcn update --vcn-id <vcn-ocid> --display-name "NewName"

# Delete a VCN
oci network vcn delete --vcn-id <vcn-ocid>
```

### Subnet Operations
```bash
# List subnets in a VCN
oci network subnet list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>

# Get subnet details
oci network subnet get --subnet-id <subnet-ocid>

# Create a public subnet
oci network subnet create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --cidr-block "10.0.1.0/24" \
  --display-name "PublicSubnet" \
  --dns-label "public" \
  --prohibit-public-ip-on-vnic false

# Create a private subnet
oci network subnet create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --cidr-block "10.0.2.0/24" \
  --display-name "PrivateSubnet" \
  --dns-label "private" \
  --prohibit-public-ip-on-vnic true

# Update subnet
oci network subnet update --subnet-id <subnet-ocid> --display-name "NewSubnetName"
```

### Security List Operations
```bash
# List security lists
oci network security-list list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>

# Get security list details
oci network security-list get --security-list-id <seclist-ocid>

# Create security list (requires JSON file for complex rules)
oci network security-list create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --display-name "WebServerSecList" \
  --ingress-security-rules '[{"protocol":"6","source":"0.0.0.0/0","tcpOptions":{"destinationPortRange":{"max":443,"min":443}}}]'

# Update security list rules
oci network security-list update \
  --security-list-id <seclist-ocid> \
  --ingress-security-rules file://ingress-rules.json \
  --egress-security-rules file://egress-rules.json
```

### Network Security Group Operations
```bash
# List NSGs
oci network nsg list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>

# Get NSG details
oci network nsg get --nsg-id <nsg-ocid>

# Create NSG
oci network nsg create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --display-name "DatabaseNSG"

# List NSG rules
oci network nsg rules list --nsg-id <nsg-ocid>

# Add NSG rule
oci network nsg rules add \
  --nsg-id <nsg-ocid> \
  --security-rules '[{"direction":"INGRESS","protocol":"6","source":"10.0.0.0/16","tcpOptions":{"destinationPortRange":{"max":1521,"min":1521}}}]'
```

### Gateway Operations
```bash
# Create Internet Gateway
oci network internet-gateway create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --is-enabled true \
  --display-name "InternetGateway"

# Create NAT Gateway
oci network nat-gateway create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --display-name "NATGateway"

# Create Service Gateway
oci network service-gateway create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --services '[{"serviceId":"<service-ocid>"}]' \
  --display-name "ServiceGateway"

# List gateways
oci network internet-gateway list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>
oci network nat-gateway list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>
oci network service-gateway list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>
```

### Route Table Operations
```bash
# List route tables
oci network route-table list --compartment-id <compartment-ocid> --vcn-id <vcn-ocid>

# Get route table details
oci network route-table get --rt-id <route-table-ocid>

# Create route table
oci network route-table create \
  --compartment-id <compartment-ocid> \
  --vcn-id <vcn-ocid> \
  --display-name "PublicRouteTable" \
  --route-rules '[{"destination":"0.0.0.0/0","networkEntityId":"<igw-ocid>"}]'

# Update route table
oci network route-table update \
  --rt-id <route-table-ocid> \
  --route-rules file://route-rules.json
```

## Best Practices

### Network Design
1. **CIDR planning**: Choose non-overlapping CIDR blocks (avoid conflicts with on-premises networks)
2. **Subnet segmentation**: Use separate subnets for different tiers (web, app, database)
3. **Public vs private**: Minimize public subnets, use private subnets with NAT gateway
4. **Availability domains**: Distribute subnets across ADs for high availability

### Security
1. **Least privilege**: Apply restrictive security rules, only open necessary ports
2. **NSG over security lists**: Use NSGs for resource-specific security (more flexible)
3. **Stateful rules**: Leverage stateful rules to automatically allow return traffic
4. **Regular audits**: Review and update security rules periodically
5. **Source restriction**: Limit SSH/RDP access to known IP ranges

### Routing
1. **Default route**: Configure default route (0.0.0.0/0) to internet gateway for public subnets
2. **Service gateway**: Route Oracle service traffic through service gateway (avoid egress charges)
3. **NAT gateway**: Use NAT gateway for private subnet internet access (updates, patches)
4. **Route table associations**: Verify subnets use correct route tables

### Scalability
1. **VCN size**: Use /16 CIDR blocks for flexibility (supports up to 65,536 IPs)
2. **Subnet sizing**: Allocate adequate IP space for growth
3. **Reserve ranges**: Keep some CIDR space reserved for future expansion
4. **VCN peering**: Plan for multi-VCN architecture if needed

## Common Workflows

### Creating a Three-Tier Application Network
1. Create VCN with /16 CIDR block (e.g., 10.0.0.0/16)
2. Create internet gateway and NAT gateway
3. Create three subnets:
   - Public subnet for load balancers (10.0.1.0/24)
   - Private subnet for app servers (10.0.2.0/24)
   - Private subnet for databases (10.0.3.0/24)
4. Configure route tables:
   - Public: default route to internet gateway
   - Private: default route to NAT gateway
5. Create NSGs:
   - Load balancer NSG: allow 80/443 from internet
   - App server NSG: allow app port from LB NSG
   - Database NSG: allow 1521/3306 from app NSG
6. Associate subnets with route tables and NSGs

### Enabling Private Instance Internet Access
1. Create NAT gateway in VCN
2. Update private subnet route table
3. Add route: destination 0.0.0.0/0, target NAT gateway
4. Verify private instances can reach internet
5. Confirm no inbound access from internet

### Implementing Network Segmentation
1. Identify application components and security requirements
2. Create separate NSGs for each component tier
3. Define security rules allowing only necessary traffic between tiers
4. Remove broad security list rules
5. Associate NSGs with compute instances or other resources
6. Test connectivity and adjust rules as needed

## Security Rule Patterns

### Common Ingress Rules
```json
// Allow HTTP from internet
{
  "protocol": "6",
  "source": "0.0.0.0/0",
  "tcpOptions": {
    "destinationPortRange": {"max": 80, "min": 80}
  }
}

// Allow HTTPS from internet
{
  "protocol": "6",
  "source": "0.0.0.0/0",
  "tcpOptions": {
    "destinationPortRange": {"max": 443, "min": 443}
  }
}

// Allow SSH from specific IP
{
  "protocol": "6",
  "source": "203.0.113.0/24",
  "tcpOptions": {
    "destinationPortRange": {"max": 22, "min": 22}
  }
}

// Allow MySQL from app subnet
{
  "protocol": "6",
  "source": "10.0.2.0/24",
  "tcpOptions": {
    "destinationPortRange": {"max": 3306, "min": 3306}
  }
}
```

### Common Egress Rules
```json
// Allow all outbound (default)
{
  "protocol": "all",
  "destination": "0.0.0.0/0"
}

// Allow HTTPS to Oracle services
{
  "protocol": "6",
  "destination": "<oci-services-cidr>",
  "tcpOptions": {
    "destinationPortRange": {"max": 443, "min": 443}
  }
}
```

## Error Handling

Common errors and resolutions:

- **"CIDR overlap"**: Choose non-overlapping CIDR blocks for subnets
- **"Route table in use"**: Cannot delete route table associated with subnets
- **"Security list in use"**: Update subnet to use different security list before deletion
- **"Gateway not attached"**: Verify gateway is created and enabled
- **"Invalid CIDR"**: Ensure CIDR notation is correct (e.g., 10.0.0.0/24)

## Integration with Other Skills

- **Compute**: Coordinate subnet and security group setup for instance launches
- **Load Balancing**: Configure subnets and security rules for load balancers
- **Database**: Set up private subnets and security rules for database systems
- **VPN/FastConnect**: Work with DRG for hybrid connectivity

## When to Use This Skill

Activate this skill when the user mentions:
- Creating or configuring VCNs, subnets, or network topology
- Setting up or modifying security lists, NSGs, or firewall rules
- Configuring gateways (internet, NAT, service, DRG)
- Managing route tables or routing configuration
- Network connectivity issues or troubleshooting
- Network security hardening or compliance
- CIDR blocks, IP addresses, or network planning
- VCN peering or multi-VCN architectures

## Example Interactions

**User**: "Create a VCN for my new application with public and private subnets"
**Response**: Use this skill to design proper CIDR allocation, create VCN with gateways, set up subnets with appropriate route tables and security rules.

**User**: "I need to allow HTTPS traffic to my web servers"
**Response**: Use this skill to add appropriate ingress rules to security list or NSG for port 443.

**User**: "How do I give my private instances internet access?"
**Response**: Use this skill to explain NAT gateway setup and route table configuration.
