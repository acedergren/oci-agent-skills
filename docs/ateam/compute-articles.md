# A-Team Chronicles: Compute Articles

Curated A-Team articles for OCI Compute Service.

---

## Automate Docker Setup on Your OCI Compute Instance

**URL**: https://www.ateam-oracle.com/automate-docker-setup-on-your-oci-compute-instance
**Topics**: Compute, Docker, Automation, Cloud-Init

**Summary**: Automate Docker installation and configuration on OCI compute instances using cloud-init user data scripts for consistent deployments.

**Key Takeaways**:
- Use cloud-init user data scripts to automate Docker setup during instance launch
- Ensures consistent Docker environment across all compute instances
- Reduces manual configuration and human error
- Can be applied to instance images for faster deployments

**When to Use This Article**:
- When launching multiple compute instances that need Docker
- When creating reusable compute instance templates
- When setting up containerized application environments on OCI

**Related OCI CLI Commands**:
```bash
# Launch compute instance with cloud-init user data
oci compute instance launch --availability-domain <AD> \
  --compartment-id <compartment-id> \
  --image-id <image-id> \
  --shape <shape> \
  --user-data-file docker-setup.sh

# Get instance details
oci compute instance get --instance-id <instance-id>
```

---

## Automate Podman Install on Your OCI Compute Instance

**URL**: https://www.ateam-oracle.com/automate-podman-install-on-your-oci-compute-instance
**Topics**: Compute, Podman, Container Runtime, Automation

**Summary**: Automate Podman (Docker alternative) installation on OCI compute instances for rootless container deployments.

**Key Takeaways**:
- Podman provides rootless container execution for improved security
- Cloud-init automation ensures consistent Podman setup
- Can be combined with cloud-init for initial VM configuration
- Useful alternative to Docker for certain workloads

**When to Use This Article**:
- When deploying containerized workloads requiring rootless execution
- When seeking a Docker-compatible container runtime alternative
- When setting up secure, daemonless container environments

---

## Windows to Linux: Use PuTTY to access an Oracle OCI Compute instance

**URL**: https://www.ateam-oracle.com/windows-to-linux-use-putty-to-access-an-oracle-oci-compute-instance
**Topics**: Compute, SSH, PuTTY, Access, Linux

**Summary**: Step-by-step guide for connecting to OCI compute instances from Windows using PuTTY SSH client.

**Key Takeaways**:
- PuTTY is a free, portable SSH client for Windows
- Requires converting OCI private key format for PuTTY compatibility
- Simplifies SSH access from Windows environments
- Includes troubleshooting for common connection issues

**When to Use This Article**:
- When accessing OCI Linux instances from Windows workstations
- When setting up SSH keys for Windows-based administrators
- When troubleshooting SSH connectivity issues from Windows

---

## Public-Private Load Balancer Combo: A solution to access private compute instances in OCI

**URL**: https://www.ateam-oracle.com/public-private-load-balancer-combo-a-solution-to-access-private-compute-instances-in-oci
**Topics**: Compute, Load Balancer, Architecture, Networking, Security

**Summary**: Multi-tier load balancer architecture pattern for secure access to private compute instances in OCI.

**Key Takeaways**:
- Public load balancer handles external traffic in public subnet
- Private load balancer manages traffic to compute instances in private subnet
- Provides security isolation while maintaining accessibility
- Common pattern for production multi-tier applications

**When to Use This Article**:
- When designing multi-tier application architectures
- When deploying applications requiring security boundaries
- When implementing load balancing for private compute instances
- When setting up production-grade OCI infrastructure

**Related OCI CLI Commands**:
```bash
# List load balancers
oci network load-balancer load-balancer list --compartment-id <compartment-id>

# Get load balancer details
oci network load-balancer load-balancer get --load-balancer-id <lb-id>
```

---

## Oracle Cloud Infrastructure Compartments

**URL**: https://www.ateam-oracle.com/oracle-cloud-infrastructure-compartments
**Topics**: Compartments, Organization, IAM, Best Practices

**Summary**: Understanding and implementing OCI compartment structure for organizing resources and managing access control.

**Key Takeaways**:
- Compartments provide logical separation and hierarchical organization of resources
- Enable role-based access control at scale
- Support cost tracking and billing allocation by compartment
- Design impacts downstream IAM policies and resource management

**When to Use This Article**:
- When planning OCI resource organization structure
- When setting up IAM policies based on compartment hierarchy
- When implementing cost allocation and billing models

**IAM Requirements**:
```
Allow group [GroupName] to manage compute in compartment [CompartmentName]
Allow group [GroupName] to read instance-images in compartment [CompartmentName]
```

---

## OCI IAM Policy Tips & Techniques – Prevent Accidental Deletion of Compute Instance with Tags

**URL**: https://www.ateam-oracle.com/post/prevent-accidental-deletion-of-compute-instance-with-tags
**Topics**: IAM, Policies, Tagging, Security, Best Practices

**Summary**: Use OCI tags and IAM policies together to prevent accidental deletion of critical compute instances.

**Key Takeaways**:
- Combine tags with IAM deny policies to protect critical resources
- Tag critical instances with specific labels (e.g., production, protected)
- Write policies that prevent termination of tagged resources
- Protects against accidental infrastructure damage

**When to Use This Article**:
- When implementing resource protection policies
- When setting up access controls for production environments
- When establishing governance around resource lifecycle management

**IAM Requirements**:
```
# Allow compute operations except deletion on tagged instances
Allow group [GroupName] to manage compute in compartment [CompartmentName]
where all {target.compute.instance.id=(tagNamespace.tagKey='protected')}

# Deny termination of protected compute instances
Deny group [GroupName] to terminate instances in compartment [CompartmentName]
where all {target.compute.instance.id=(tagNamespace.tagKey='production')}
```

---

## OCI Public and Private Subnets in Association with Internet and NAT Gateways (Part-1)

**URL**: https://www.ateam-oracle.com/oci-public-and-private-subnets-in-association-with-internet-and-nat-gateways
**Topics**: Networking, Subnets, Gateways, VCN, Security

**Summary**: Understanding subnet types, Internet Gateways, and NAT Gateways for secure network architecture in OCI.

**Key Takeaways**:
- Public subnets use Internet Gateways for external connectivity
- Private subnets use NAT Gateways for outbound-only access
- Route tables determine how traffic is directed through gateways
- Proper gateway configuration ensures security and connectivity

**When to Use This Article**:
- When designing OCI VCN network architecture
- When configuring compute instance connectivity
- When implementing security boundaries between subnets

**Related OCI CLI Commands**:
```bash
# List subnets
oci network subnet list --compartment-id <compartment-id>

# Get subnet details
oci network subnet get --subnet-id <subnet-id>

# List internet gateways
oci network internet-gateway list --compartment-id <compartment-id>
```

---

## Connecting to Private ODI Marketplace with VNC Viewer

**URL**: https://www.ateam-oracle.com/connecting-to-private-odi-marketplace-with-vnc-viewer
**Topics**: Compute, Remote Desktop, VNC, Private Network, Marketplace

**Summary**: Access GUI-based marketplace applications running on private OCI compute instances using VNC Viewer.

**Key Takeaways**:
- VNC Viewer enables remote desktop access to GUI applications
- Useful for marketplace applications requiring graphical interface
- Can tunnel through bastion hosts or jumpboxes for private instances
- Alternative to SSH for GUI-based tools

**When to Use This Article**:
- When accessing GUI applications on OCI compute instances
- When using marketplace images with graphical interfaces
- When managing private instances requiring graphical access

---

## Bulk Editing Tags on Resources using the OCI CLI

**URL**: https://ateam-oracle.com/post/bulk-editing-tags-on-resources-using-the-oci-cli
**Topics**: Tags, CLI, Bulk Operations, Resource Management

**Summary**: Efficiently apply, update, or remove tags across multiple OCI resources using CLI commands.

**Key Takeaways**:
- Tags enable resource organization, cost tracking, and access control
- CLI allows bulk tagging operations vs manual console tagging
- Combine with filters to target specific resource sets
- Essential for large-scale resource management

**When to Use This Article**:
- When applying consistent tagging across compute instances
- When updating resource classifications at scale
- When implementing governance through tags

**Relevant Commands**:
```bash
# List compute instances with specific tag
oci compute instance list --compartment-id <compartment-id> \
  --query "data[?contains(\"freeformTags\".env, 'production')]"

# Get instances for tag update operations
oci compute instance list --compartment-id <compartment-id>
```

---

## Article Search

To find more Compute articles from A-Team:
```
Google: site:ateam-oracle.com "compute" "instance"
Google: site:blogs.oracle.com/ateam "OCI compute"
Google: site:docs.oracle.com "a-team" "compute"
```

## Related Resources

- **Official Docs**: Use Context7 to query "OCI Compute documentation"
- **OCI Reference**: See `docs/references/oci-compute-reference.md`
- **Skill File**: See `skills/compute-management/SKILL.md`

---

*Curated by: Agent Skill OCI Plugin*
*Last Updated: 2026-01-26*
