# OCI Compute Service - Quick Reference

> Lightweight reference for OCI Compute operations. Use Context7 MCP server for detailed documentation.

## Service Overview

**Compute Service**: Scalable virtual machines and bare metal servers
- **CLI Namespace**: `oci compute`
- **Python SDK**: `oci.core.ComputeClient`
- **Official Docs**: https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm

## Common Operations

### Instance Management

**List instances in compartment**:
```bash
oci compute instance list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state RUNNING
```

**Launch instance**:
```bash
oci compute instance launch \
  --availability-domain <ad-name> \
  --compartment-id <compartment-ocid> \
  --shape VM.Standard.E4.Flex \
  --shape-config '{"ocpus": 1, "memoryInGBs": 16}' \
  --subnet-id <subnet-ocid> \
  --image-id <image-ocid> \
  --display-name my-instance
```

**Instance actions** (start/stop/reset):
```bash
oci compute instance action \
  --instance-id <instance-ocid> \
  --action STOP
```

### VNIC Operations

**List VNICs attached to instance**:
```bash
oci compute instance list-vnics \
  --instance-id <instance-ocid>
```

**Attach secondary VNIC**:
```bash
oci compute vnic-attachment attach \
  --instance-id <instance-ocid> \
  --subnet-id <subnet-ocid>
```

### Console Access

**Create console connection**:
```bash
oci compute instance-console-connection create \
  --instance-id <instance-ocid> \
  --ssh-public-key-file ~/.ssh/id_rsa.pub
```

## Instance Shapes

| Family | Use Case | Example Shapes |
|--------|----------|----------------|
| VM.Standard.E4.Flex | General purpose, flexible | 1-64 OCPUs |
| VM.Standard.A1.Flex | Ampere ARM, cost-effective | 1-80 OCPUs |
| BM.Standard3.64 | Bare metal, high performance | 64 OCPUs |
| VM.GPU.A10.1 | GPU compute | 1x A10 GPU |

## Image Management

**List available images**:
```bash
oci compute image list \
  --compartment-id <compartment-ocid> \
  --operating-system "Oracle Linux" \
  --shape VM.Standard.E4.Flex
```

**Create custom image from instance**:
```bash
oci compute image create \
  --compartment-id <compartment-ocid> \
  --instance-id <instance-ocid> \
  --display-name my-custom-image
```

## Best Practices

1. **Right-size instances**: Start with Flex shapes, scale based on metrics
2. **Use custom images**: Create golden images for consistent deployments
3. **Tagging**: Apply freeform and defined tags for organization
4. **Monitoring**: Enable compute metrics in OCI Monitoring
5. **Security**: Use bastion hosts, never expose instances directly

## IAM Policies

**Allow group to manage compute instances**:
```
Allow group ComputeAdmins to manage instance-family in compartment Production
```

**Allow instances to call services** (instance principal):
```
Allow dynamic-group AppInstances to use object-family in compartment Production
```

## Troubleshooting

### Instance won't launch
- Verify service limits: `oci limits value list`
- Check availability domain capacity
- Validate IAM permissions
- Verify subnet has available IPs

### Can't connect to instance
- Check security list/NSG rules for port 22 (SSH) or 3389 (RDP)
- Verify public IP assigned if using internet gateway
- Check instance firewall (OS-level)
- Verify SSH key matches

### Instance running slow
- Check CPU utilization in monitoring
- Review disk I/O performance
- Consider shape with higher IOPS (Ultra High Performance boot volume)
- Check for noisy neighbor (if VM) - consider bare metal

## Documentation Links

For detailed information, use Context7 MCP server to query:
- **Compute overview**: "OCI compute documentation"
- **CLI reference**: "OCI CLI compute commands"
- **Shape details**: "OCI compute shapes"
- **Networking**: "OCI VNIC configuration"

## Python SDK Examples

**Launch instance with SDK**:
```python
from oci import core, identity
from oci.config import from_file

config = from_file()
compute_client = core.ComputeClient(config)

launch_details = core.models.LaunchInstanceDetails(
    availability_domain="AD-1",
    compartment_id="ocid1.compartment.oc1...",
    shape="VM.Standard.E4.Flex",
    shape_config=core.models.LaunchInstanceShapeConfigDetails(
        ocpus=1,
        memory_in_gbs=16
    ),
    display_name="my-instance",
    subnet_id="ocid1.subnet.oc1...",
    source_details=core.models.InstanceSourceViaImageDetails(
        image_id="ocid1.image.oc1...",
        source_type="image"
    )
)

instance = compute_client.launch_instance(launch_details).data
print(f"Launched: {instance.id}")
```

---

*This is a quick reference. For comprehensive documentation, use the Context7 MCP server or visit https://docs.oracle.com/en-us/iaas/Content/Compute/home.htm*
