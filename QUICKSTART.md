# OCI Cloud Operations Plugin - Quick Start Guide

Get started with the OCI Cloud Operations plugin for Claude Code in 5 minutes.

## Prerequisites

1. **OCI CLI installed and configured**
   ```bash
   # Install OCI CLI
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

   # Configure OCI CLI
   oci setup config
   ```

2. **Claude Code installed**
   - Follow instructions at [claude.ai/code](https://claude.ai/code)

## Installation

### Method 1: Direct Copy (Recommended)
```bash
# Clone or copy plugin to Claude plugins directory
cp -r agent-skill-oci ~/.claude/plugins/oci-cloud-ops

# Restart Claude Code
```

### Method 2: Symlink for Development
```bash
# Create symlink for easier updates
ln -s $(pwd)/agent-skill-oci ~/.claude/plugins/oci-cloud-ops

# Restart Claude Code
```

## Verify Installation

Open Claude Code and try:

```
/help
```

You should see the OCI plugin skills available.

## Your First Commands

### 1. List Compute Instances
```
User: List all compute instances in my compartment

Claude will:
- Activate compute-management skill
- Execute: oci compute instance list --compartment-id <your-compartment>
- Show results in organized format
```

### 2. Create a VCN
```
User: Create a VCN for a web application with public and private subnets

Claude will:
- Activate networking-management skill
- Design appropriate CIDR blocks
- Create VCN, subnets, gateways
- Set up security rules
- Provide complete CLI commands
```

### 3. Set Up Monitoring
```
User: Alert me when CPU usage exceeds 80% on my instances

Claude will:
- Activate monitoring-operations skill
- Create notification topic
- Set up alarm with proper threshold
- Configure notifications
```

## Common Use Cases

### Scenario 1: Launch a Web Server

**User Request:**
```
Create a web server instance accessible from the internet
```

**What Happens:**
1. Claude activates **compute-management** and **networking-management** skills
2. Verifies/creates VCN and public subnet
3. Configures security rules for HTTP/HTTPS
4. Launches instance with Oracle Linux
5. Provides SSH access details

**Commands Executed:**
```bash
oci compute instance launch \
  --availability-domain <ad> \
  --compartment-id <compartment-ocid> \
  --shape VM.Standard.E4.Flex \
  --subnet-id <subnet-ocid> \
  --image-id <image-ocid> \
  --display-name "WebServer"
```

### Scenario 2: Create Development Database

**User Request:**
```
Set up an always-free Autonomous Database for testing
```

**What Happens:**
1. Claude activates **database-management** skill
2. Creates ATP database with free tier settings
3. Downloads wallet for connection
4. Provides connection instructions

**Commands Executed:**
```bash
oci db autonomous-database create \
  --compartment-id <compartment-ocid> \
  --db-name testdb \
  --display-name "Test Database" \
  --admin-password "<secure-password>" \
  --cpu-core-count 1 \
  --data-storage-size-in-tbs 1 \
  --db-workload OLTP \
  --is-free-tier true
```

### Scenario 3: Store API Key Securely

**User Request:**
```
I need to store my GitHub API token securely
```

**What Happens:**
1. Claude activates **secrets-management** skill
2. Creates/selects vault
3. Creates encryption key
4. Stores secret with proper encryption
5. Shows how to retrieve in application

**Commands Executed:**
```bash
# Create secret
oci vault secret create-base64 \
  --compartment-id <compartment-ocid> \
  --vault-id <vault-ocid> \
  --key-id <key-ocid> \
  --secret-name "github-token" \
  --secret-content-content "$(echo -n 'ghp_xxx' | base64)"

# Retrieve secret
oci secrets secret-bundle get \
  --secret-id <secret-ocid> \
  --query 'data."secret-bundle-content".content' \
  --raw-output | base64 -d
```

### Scenario 4: Build AI-Powered App

**User Request:**
```
Help me add a chatbot to my application using OCI GenAI
```

**What Happens:**
1. Claude activates **genai-services** skill
2. Explains available models
3. Shows how to call chat API
4. Provides complete Python code example
5. Configures IAM policies

**Example Code:**
```python
from oci.generative_ai_inference import GenerativeAiInferenceClient

client = GenerativeAiInferenceClient(config)

response = client.chat(
    chat_detail=ChatDetails(
        compartment_id=compartment_id,
        serving_mode=OnDemandServingMode(model_id=model_id),
        chat_request=CohereChatRequest(
            message="How do I create a VCN?",
            max_tokens=500
        )
    )
)
```

## Understanding Skill Activation

Skills activate automatically based on keywords:

| Skill | Activation Keywords |
|-------|-------------------|
| **compute-management** | instance, VM, compute, server, launch, terminate |
| **networking-management** | VCN, subnet, security list, NSG, gateway, network |
| **database-management** | database, ADB, ATP, ADW, DB System, Oracle database |
| **monitoring-operations** | metrics, alarm, log, monitoring, alert, notification |
| **secrets-management** | secret, vault, encryption key, password, credential |
| **genai-services** | GenAI, AI, LLM, chat, embeddings, generation |
| **iam-identity-management** | IAM, policy, user, group, permission, access |
| **infrastructure-as-code** | Terraform, IaC, Resource Manager, landing zone |

## Advanced Features

### Using MCP Servers

The plugin includes MCP server integration:

**Context7 for Latest Documentation:**
```
User: What are the new features in OCI Compute?

Claude automatically:
- Queries Context7 for latest OCI Compute docs
- Provides up-to-date information
- References official documentation
```

**OCI API for Direct Access:**
```
User: Get detailed metrics for my load balancer

Claude automatically:
- Uses OCI API MCP server
- Retrieves metrics data
- Presents in readable format
```

### OCI Cloud Architect Agent

For complex, multi-service scenarios:

```
User: Design a highly available three-tier web application

Claude activates oci-cloud-architect agent which:
1. Asks clarifying questions about requirements
2. Designs complete architecture
3. Coordinates multiple skills for implementation
4. Ensures best practices across all services
5. Sets up monitoring and security
```

## Configuration

### Set Default Region
Edit your OCI CLI config (`~/.oci/config`):
```ini
[DEFAULT]
user=ocid1.user.oc1...
fingerprint=xx:xx:xx...
tenancy=ocid1.tenancy.oc1...
region=us-phoenix-1
key_file=~/.oci/oci_api_key.pem
```

### Configure Plugin
Edit `.mcp.json` to enable/disable MCP servers:
```json
{
  "mcpServers": {
    "oci-api": {
      "disabled": false
    },
    "context7": {
      "disabled": false
    }
  }
}
```

## Tips for Best Results

### Be Specific
❌ "Create a server"
✅ "Create a VM.Standard.E4.Flex instance in the public subnet"

### Mention Environment
✅ "Create a production database with high availability"
✅ "Set up a development environment with cost optimization"

### Ask for Explanations
✅ "Explain why you chose this security configuration"
✅ "What are the cost implications of this setup?"

### Request Best Practices
✅ "What are the security best practices for this setup?"
✅ "How should I structure my compartments for this project?"

## Troubleshooting

### Skill Not Activating
**Problem**: Claude isn't using the OCI skills

**Solution**:
- Use OCI-specific terminology (VCN not VPC, ADB not RDS)
- Mention "OCI" explicitly: "Create an OCI compute instance"
- Be specific about the service: "Autonomous Database" not just "database"

### CLI Commands Failing
**Problem**: CLI commands return authentication errors

**Solution**:
```bash
# Verify OCI CLI config
oci iam region list

# Check compartment access
oci iam compartment get --compartment-id <your-compartment>

# Verify IAM permissions
oci iam policy list --compartment-id <your-compartment>
```

### Can't Find Resources
**Problem**: Can't see instances or other resources

**Solution**:
- Verify you're in the correct region
- Check compartment OCID is correct
- Ensure you have IAM permissions to view resources

## Next Steps

1. **Explore All Skills**: Try each skill with different scenarios
2. **Read Skill Documentation**: Check SKILL.md files for comprehensive examples
3. **Use Terraform**: Create infrastructure as code with the IaC skill
4. **Set Up Monitoring**: Configure comprehensive observability
5. **Implement Security**: Use Vault for secrets, proper IAM policies

## Getting Help

- **Plugin README**: `README.md` for comprehensive documentation
- **Skill Details**: Check `skills/*/SKILL.md` for detailed references
- **OCI Docs**: Use Context7 integration for latest documentation
- **Example Prompts**: See README for more usage examples

## Quick Reference Card

```
┌─────────────────────────────────────────────────────┐
│ OCI CLOUD OPERATIONS PLUGIN - QUICK REFERENCE       │
├─────────────────────────────────────────────────────┤
│ Compute:   "Launch instance" "Stop VM"              │
│ Network:   "Create VCN" "Configure security"        │
│ Database:  "Create ADB" "Backup database"           │
│ Monitor:   "Set up alarms" "Query metrics"          │
│ Secrets:   "Store password" "Create vault"          │
│ GenAI:     "Generate text" "Create chatbot"         │
│ IAM:       "Create policy" "Add user to group"      │
│ IaC:       "Terraform for..." "Resource Manager"    │
└─────────────────────────────────────────────────────┘
```

---

**Ready to start?** Try: "Show me all my compute instances"
