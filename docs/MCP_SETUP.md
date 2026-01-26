# Optional MCP Server Setup Guide

This plugin includes integration with Oracle's official MCP servers for enhanced capabilities. These servers are currently reference implementations from the [oracle/mcp](https://github.com/oracle/mcp) repository and require local installation.

## Core MCP Servers (Pre-configured)

These servers work out of the box:

- ✅ **oci-api**: Oracle Cloud Infrastructure API access
- ✅ **context7**: Up-to-date OCI documentation retrieval

## Optional MCP Servers (Manual Setup Required)

These servers provide enhanced capabilities but require local installation:

### Available Servers

1. **oracle-oci-pricing**: Real-time pricing lookups by SKU or product name
2. **oracle-oci-usage**: Cost and usage analytics for FinOps automation
3. **oracle-oci-resource-search**: Cross-compartment resource discovery
4. **oracle-oci-cloud-guard**: Security issues and recommendations

## Installation Steps

### 1. Clone Oracle MCP Repository

```bash
cd ~/Projects  # or your preferred location
git clone https://github.com/oracle/mcp.git oracle-mcp
cd oracle-mcp
```

### 2. Set Up Python Environment

```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment
uv venv --python 3.13 --seed
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
uv pip install -r requirements-dev.txt
```

### 3. Build and Install Servers

```bash
# Build all MCP servers
make build

# Install to local environment
make install
```

### 4. Configure OCI Authentication

```bash
# Set up OCI CLI (if not already configured)
oci setup config

# Or use session authentication
oci session authenticate --region=us-phoenix-1 --tenancy-name=<your-tenancy>
```

### 5. Update Plugin Configuration

Edit your `.mcp.json` in the plugin directory:

#### For Pricing Server (No OCI auth required)

```json
{
  "mcpServers": {
    "oracle-oci-pricing": {
      "command": "uv",
      "args": ["run", "oracle.oci-pricing-mcp-server"],
      "env": {
        "VIRTUAL_ENV": "/Users/yourusername/Projects/oracle-mcp/.venv",
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "description": "Real-time OCI pricing lookups",
      "disabled": false
    }
  }
}
```

#### For Usage Server (Requires OCI auth)

```json
{
  "mcpServers": {
    "oracle-oci-usage": {
      "command": "uv",
      "args": ["run", "oracle.oci-usage-mcp-server"],
      "env": {
        "VIRTUAL_ENV": "/Users/yourusername/Projects/oracle-mcp/.venv",
        "OCI_CONFIG_PROFILE": "DEFAULT",
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "description": "Cost and usage analytics",
      "disabled": false
    }
  }
}
```

#### For Resource Search Server

```json
{
  "mcpServers": {
    "oracle-oci-resource-search": {
      "command": "uv",
      "args": ["run", "oracle.oci-resource-search-mcp-server"],
      "env": {
        "VIRTUAL_ENV": "/Users/yourusername/Projects/oracle-mcp/.venv",
        "OCI_CONFIG_PROFILE": "DEFAULT",
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "description": "Cross-compartment resource discovery",
      "disabled": false
    }
  }
}
```

#### For Cloud Guard Server

```json
{
  "mcpServers": {
    "oracle-oci-cloud-guard": {
      "command": "uv",
      "args": ["run", "oracle.oci-cloud-guard-mcp-server"],
      "env": {
        "VIRTUAL_ENV": "/Users/yourusername/Projects/oracle-mcp/.venv",
        "OCI_CONFIG_PROFILE": "DEFAULT",
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "description": "Cloud Guard security recommendations",
      "disabled": false
    }
  }
}
```

**Note**: Replace `/Users/yourusername/Projects/oracle-mcp/.venv` with your actual path.

## Testing MCP Servers

### Test Pricing Server (No auth required)

```bash
cd ~/Projects/oracle-mcp
source .venv/bin/activate
uv run oracle.oci-pricing-mcp-server

# In another terminal, test with MCP Inspector
npx @modelcontextprotocol/inspector uv run oracle.oci-pricing-mcp-server
```

### Test Usage Server (Requires OCI auth)

```bash
cd ~/Projects/oracle-mcp
source .venv/bin/activate
OCI_CONFIG_PROFILE=DEFAULT uv run oracle.oci-usage-mcp-server
```

## Troubleshooting

### "Package not found" Error

The oracle/mcp servers are reference implementations not published to PyPI. You must clone and build them locally.

### Authentication Errors

Ensure your OCI CLI is configured:

```bash
# Check OCI config
cat ~/.oci/config

# Test authentication
oci iam region list

# Refresh session token if expired
oci session authenticate --profile-name DEFAULT --region <region> --auth security_token
```

### Permission Errors

Ensure your OCI user/profile has appropriate permissions:

```bash
# For usage server, you need:
# - read access to tenancy
# - usage-report permissions

# For resource search:
# - read access to compartments
# - inspect permissions across services

# For Cloud Guard:
# - read access to Cloud Guard
# - inspect permissions for problems
```

### Virtual Environment Path Issues

If the server fails to start, verify the VIRTUAL_ENV path:

```bash
# Get absolute path
cd ~/Projects/oracle-mcp
pwd
# Use this output + "/.venv" for VIRTUAL_ENV
```

## Feature Availability Without Optional Servers

The plugin provides full functionality even without these optional servers:

- ✅ All 10 skills work with OCI CLI commands
- ✅ Complete command references (800+ commands)
- ✅ Documentation and best practices
- ✅ Core MCP servers (oci-api, context7)

The optional servers provide:
- 📊 Real-time pricing lookups (vs manual calculations)
- 📈 Automated usage analytics (vs CLI queries)
- 🔍 Fast cross-compartment search (vs compartment-by-compartment)
- 🛡️ Automated security recommendations (vs manual review)

## Alternative: Wait for Official Release

Oracle is actively developing these MCP servers. They may be published to PyPI in the future, making installation simpler. Check the [oracle/mcp repository](https://github.com/oracle/mcp) for updates.

## Support

For issues with:
- **Plugin functionality**: Open issue at https://github.com/acedergren/agent-skill-oci/issues
- **MCP servers**: Open issue at https://github.com/oracle/mcp/issues
- **OCI authentication**: Check [OCI CLI documentation](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
