# OCI [Service Name] - Quick Reference

> Lightweight reference for OCI [Service] operations. Use Context7 MCP server for detailed documentation.

## Service Overview

**[Service Name]**: [Brief description]
- **CLI Namespace**: `oci [service]`
- **Python SDK**: `oci.[module].[Client]`
- **Official Docs**: [URL]

## Common Operations

### [Operation Category 1]

**[Operation description]**:
```bash
oci [service] [resource] [action] \
  --[param1] <value1> \
  --[param2] <value2>
```

### [Operation Category 2]

**[Another operation]**:
```bash
oci [service] [resource] [action] \
  --[required-param] <value>
```

## Resource Types

| Resource | Description | CLI Command |
|----------|-------------|-------------|
| [Type 1] | [Description] | `oci [service] [type1]` |
| [Type 2] | [Description] | `oci [service] [type2]` |

## Best Practices

1. **[Practice 1]**: [Explanation]
2. **[Practice 2]**: [Explanation]
3. **[Practice 3]**: [Explanation]
4. **[Practice 4]**: [Explanation]
5. **[Practice 5]**: [Explanation]

## IAM Policies

**Allow group to [action]**:
```
Allow group [GroupName] to [verb] [resource-type] in compartment [Compartment]
```

**Allow instances to [action]** (instance principal):
```
Allow dynamic-group [DynamicGroup] to [verb] [resource-type] in compartment [Compartment]
```

## Troubleshooting

### [Common Issue 1]
- [Potential cause 1]
- [Potential cause 2]
- [Solution approach]

### [Common Issue 2]
- [Diagnostic steps]
- [Resolution]

### [Common Issue 3]
- [Symptoms]
- [Fix]

## Documentation Links

For detailed information, use Context7 MCP server to query:
- **[Topic 1]**: "[search query]"
- **[Topic 2]**: "[search query]"
- **[Topic 3]**: "[search query]"

## Python SDK Examples

**[Common operation with SDK]**:
```python
from oci import [module]
from oci.config import from_file

config = from_file()
client = [module].[Client](config)

# Example operation
result = client.[method]([params]).data
print(f"Result: {result}")
```

**[Another SDK example]**:
```python
from oci import [module]
from oci.config import from_file

config = from_file()
client = [module].[Client](config)

# Create/update operation
details = [module].models.[DetailsModel](
    param1="value1",
    param2="value2"
)

response = client.[create_method](details).data
print(f"Created: {response.id}")
```

---

*This is a quick reference. For comprehensive documentation, use the Context7 MCP server or visit [Official Docs URL]*
