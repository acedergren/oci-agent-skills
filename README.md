# OCI Agent Skills for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://code.claude.com)
[![GitHub Marketplace](https://img.shields.io/badge/Available%20on-Claude%20Code%20Marketplace-blue)](https://code.claude.com/docs/en/discover-plugins)
[![Skills Count](https://img.shields.io/badge/Skills-10%2B1%20Agent-brightgreen)](#skills-reference)
[![Community Project](https://img.shields.io/badge/Community-Maintained-success)](https://github.com/acedergren/oci-agent-skills)

> **⚠️ Community Project Notice**: OCI Agent Skills is a **community-maintained** project created and maintained by Alexander Cedergren. This is **not an official Oracle product**. It provides helpful utilities, examples, and best practices for working with Oracle Cloud Infrastructure, but is not endorsed by or affiliated with Oracle Corporation.

Comprehensive Oracle Cloud Infrastructure (OCI) agent skills plugin for Claude Code - intelligent automation for managing cloud resources across compute, networking, databases, monitoring, and more.

## ⚡ Quick Start

### Quickest: Using OpenSkills CLI

```bash
npx skills add acedergren/oci-agent-skills
```

That's it! The OCI skills are now available.

### Alternative: Claude Code Marketplace

```bash
# Add the marketplace (one-time)
/plugin marketplace add acedergren/oci-agent-skills

# Install the plugin
/plugin install oci-agent-skills
```

Both methods install the same plugin - choose whichever is more convenient for your workflow.

### First Steps

Try these prompts in Claude Code:

1. **Compute**: "Help me launch an OCI compute instance for a web server"
2. **Networking**: "I need to create a VCN with public and private subnets"
3. **Database**: "Create an Autonomous Database for my application"
4. **FinOps**: "Show me my top spending services and optimization opportunities"

## Overview

This community-maintained plugin provides expert-level guidance and complete CLI command references for OCI services, compensating for Claude's limited training on Oracle Cloud Infrastructure. Created and maintained by Alexander Cedergren, it includes **10 detailed skills** plus an **OCI Cloud Architect orchestrator agent** for intelligent multi-service automation. Skills cover compute, networking, databases, monitoring, secrets management, GenAI services, IAM/identity management, infrastructure as code, FinOps/cost optimization, and best practices from Oracle's official documentation and technical guides.

**This is a community project and is not an official Oracle product or endorsement.**

## Features

### 🎯 Comprehensive Skills Coverage

**10 Specialized Skills:**
- **Compute Management**: Launch, manage, and troubleshoot compute instances
- **Networking**: VCN, subnet, security group, and gateway configuration
- **Database Management**: Autonomous Database, DB Systems, Exadata, and PDBs
- **Monitoring & Observability**: Metrics, alarms, logs, and events
- **Secrets Management**: OCI Vault for secure credential storage
- **Generative AI**: Foundation models, embeddings, chat, and fine-tuning
- **IAM & Identity**: Users, groups, policies, dynamic groups, and IDCS integration
- **Infrastructure as Code**: Terraform, Resource Manager, and Landing Zones
- **FinOps & Cost Optimization**: Usage analytics, anomaly detection, budgets, and cost intelligence
- **Best Practices**: Official Oracle guidance, Well-Architected Framework, CIS compliance

**🤖 Intelligent Orchestrator Agent:**
- **OCI Cloud Architect**: Multi-skill coordinator for complex, end-to-end cloud solutions
  - Designs comprehensive architectures spanning multiple OCI services
  - Coordinates implementation across compute, networking, database, security, and monitoring
  - Troubleshoots complex multi-service issues systematically
  - Applies best practices and security compliance throughout
  - Optimizes for cost, performance, and operational excellence

### 🔌 MCP Server Integration

**Core Servers (Pre-configured)**
- **OCI API**: Direct access to OCI APIs through MCP
- **Context7**: Retrieves up-to-date OCI documentation and references

**Optional Servers** (Require [local setup](docs/MCP_SETUP.md))
- **OCI Pricing**: Real-time pricing lookups by SKU or product name
- **OCI Usage**: Cost and usage analytics for FinOps automation
- **OCI Resource Search**: Cross-compartment resource discovery
- **OCI Cloud Guard**: Cloud security issues and recommendations

*Note: Plugin provides full functionality without optional servers. See [MCP Setup Guide](docs/MCP_SETUP.md) for installation.*

### 📚 Complete CLI References

Each skill includes:
- Comprehensive OCI CLI command examples with all parameters
- Common usage patterns and workflows
- Python SDK examples for automation
- Best practices and security considerations
- Troubleshooting guides and error resolution
- IAM policy examples

## Installation

### Option 1: OpenSkills CLI (Recommended)

The quickest way to install:

```bash
npx skills add acedergren/oci-agent-skills
```

**Benefits:**
- ✅ Single command installation
- ✅ Works with Claude Code and other AI agents
- ✅ Automatic skill syncing
- ✅ Easy to manage with `npx skills` commands

### Option 2: Claude Code Marketplace

Install through Claude Code's native marketplace:

```bash
# Add the marketplace (one-time setup)
/plugin marketplace add acedergren/oci-agent-skills

# Install the plugin
/plugin install oci-agent-skills
```

**Benefits:**
- ✅ Integrated into Claude Code
- ✅ Automatic updates
- ✅ Easy management through Claude Code UI

### Option 3: Manual Installation

If you prefer to manage the plugin locally:

```bash
# Clone the repository
git clone https://github.com/acedergren/oci-agent-skills.git ~/.claude/plugins/oci-agent-skills

# Restart Claude Code
```

Then verify installation:
```bash
/help
```

You should see OCI skills listed.

## Plugin Structure

```
oci-agent-skills/
├── .claude-plugin/
│   ├── plugin.json           # Plugin manifest
│   └── marketplace.json      # Marketplace metadata
├── .mcp.json                 # MCP server configuration
├── agents/                   # Orchestrator agents
│   └── oci-cloud-architect.md   # Multi-skill orchestration agent
├── skills/                   # 10 Auto-activating specialist skills
│   ├── compute-management/
│   │   └── SKILL.md
│   ├── networking-management/
│   │   └── SKILL.md
│   ├── database-management/
│   │   └── SKILL.md
│   ├── monitoring-operations/
│   │   └── SKILL.md
│   ├── secrets-management/
│   │   └── SKILL.md
│   ├── genai-services/
│   │   └── SKILL.md
│   ├── iam-identity-management/
│   │   └── SKILL.md
│   ├── infrastructure-as-code/
│   │   └── SKILL.md
│   ├── finops-cost-optimization/
│   │   └── SKILL.md
│   └── best-practices/
│       └── SKILL.md
└── README.md
```

## Skills Reference

### Compute Management
Activate when working with:
- VM instances, bare metal servers
- Instance lifecycle (launch, stop, terminate)
- VNIC and networking configuration
- Console access and troubleshooting

**Example**: "Launch a web server instance in production"

### Networking Management
Activate when working with:
- VCNs, subnets, CIDR planning
- Security lists, NSGs, firewall rules
- Internet gateway, NAT gateway, service gateway
- Route tables and routing configuration

**Example**: "Create a VCN with public and private subnets"

### Database Management
Activate when working with:
- Autonomous Database (ATP/ADW)
- DB Systems and RAC
- Database backups and cloning
- PDB management
- Connection wallets

**Example**: "Create an Autonomous Database for development"

### Monitoring Operations
Activate when working with:
- Metrics queries and visualization
- Alarms and notifications
- Log collection and search
- Event rules and automation

**Example**: "Set up CPU monitoring for my instances"

### Secrets Management
Activate when working with:
- OCI Vault for credential storage
- Encryption key management
- Secret rotation and versioning
- Application secret retrieval

**Example**: "Store database password securely"

### Generative AI Services
Activate when working with:
- Foundation models (Cohere, Llama)
- Text generation and chat
- Embeddings for semantic search
- Model fine-tuning

**Example**: "Generate text using OCI GenAI"

### IAM & Identity Management
Activate when working with:
- Users, groups, policies
- Dynamic groups and instance principals
- IDCS integration and SSO
- Access troubleshooting

**Example**: "Create a policy for developers to manage compute"

### FinOps & Cost Optimization
Activate when working with:
- Cost and usage reporting
- Budget management and alerts
- Anomaly detection with ADB ML
- Resource optimization and right-sizing
- Reserved capacity planning
- Pricing lookups and estimates

**Example**: "Show my top spending services and identify idle resources"

## Orchestrator Agent

### OCI Cloud Architect

The **OCI Cloud Architect** is an intelligent orchestrator agent that coordinates the 10 specialist skills to handle complex, multi-service cloud architecture scenarios. It automatically activates when you need end-to-end solutions that span multiple OCI services.

**When the agent activates:**
- Designing comprehensive cloud architectures
- Planning infrastructure spanning multiple services
- Troubleshooting complex, multi-service issues
- Optimizing entire workloads for performance and cost
- Implementing best practices across multiple services

**Multi-Skill Coordination Examples:**

1. **Three-Tier Application Architecture**
   - Uses: Compute, Networking, Database, Monitoring, Security, IAM
   - Designs web tier, app tier, database tier with security
   - Configures networking between tiers
   - Sets up monitoring and alerting across all services
   - Applies IAM policies for least-privilege access
   - Optimizes for cost and performance

2. **Disaster Recovery Setup**
   - Uses: Database, Compute, Networking, Monitoring
   - Plans primary and standby regions
   - Configures failover mechanisms
   - Monitors replication health
   - Documents recovery procedures

3. **Secure Multi-Environment Setup**
   - Uses: Networking, IAM, Secrets, Compute, Monitoring
   - Creates dev, staging, production compartments
   - Configures network isolation
   - Sets up environment-specific IAM policies
   - Manages secrets per environment
   - Implements cross-environment monitoring

**How It Differs from Individual Skills:**

| Aspect | Individual Skills | Orchestrator Agent |
|--------|---|---|
| **Scope** | Single service (compute, database, etc.) | Multiple services together |
| **Planning** | Commands for one service | End-to-end architecture |
| **Coordination** | Independent | Coordinates between skills |
| **Use Case** | "Create a database" | "Build a secure 3-tier app" |
| **Best Practices** | Service-specific | Cross-service, holistic |

## Usage Examples

### Basic Compute Operations

```bash
# Claude automatically activates compute-management skill
User: "List all running instances in my production compartment"

# Skill provides complete CLI command with explanations
Response: Uses OCI CLI to list instances with appropriate filters
```

### Network Setup

```bash
User: "I need to create a three-tier application network"

# Skill guides through complete setup
Response:
1. Creates VCN with proper CIDR
2. Sets up subnets (public, app, database)
3. Configures security groups
4. Establishes routing
```

### Database Creation

```bash
User: "Create an always-free ATP database for testing"

# Skill provides exact command with all parameters
Response: Executes oci db autonomous-database create with
         appropriate free-tier settings
```

### Secrets Management

```bash
User: "Store my API key securely"

# Skill walks through vault setup
Response:
1. Creates/selects vault
2. Creates encryption key
3. Stores secret
4. Shows retrieval command
```

## MCP Server Usage

The plugin integrates with MCP servers for enhanced functionality:

### OCI API Server
Provides direct API access for operations not covered by CLI:

```python
# Use oci-api MCP server tools directly
# Claude will automatically call these when needed
```

### Context7 Documentation
Retrieves latest OCI documentation:

```bash
# Claude automatically queries Context7 for:
# - Latest CLI syntax
# - New service features
# - Updated API references
```

## Configuration

### OCI CLI Setup
Ensure OCI CLI is configured:

```bash
oci setup config
```

This creates `~/.oci/config` with your credentials.

### MCP Servers
The plugin automatically enables:
- `oci-api`: Oracle Cloud API access
- `context7`: Live documentation retrieval

To disable an MCP server, edit `.mcp.json`:

```json
{
  "mcpServers": {
    "oci-api": {
      "disabled": true
    }
  }
}
```

## Best Practices

### Security
1. **Never hardcode credentials**: Use OCI Vault for secrets
2. **Least privilege**: Apply minimal IAM permissions
3. **Regular rotation**: Rotate API keys and passwords quarterly
4. **Audit logging**: Enable and review audit logs

### Cost Optimization
1. **Stop idle instances**: Stop dev/test instances when not in use
2. **Right-size resources**: Start small, scale based on metrics
3. **Use always-free**: Leverage free tier for development
4. **Monitor spending**: Set up budget alerts

### Operations
1. **Tagging strategy**: Apply consistent tags for organization
2. **Compartment design**: Plan logical hierarchy upfront
3. **Backup strategy**: Implement regular backups
4. **Monitoring**: Set up comprehensive monitoring and alarms

## Troubleshooting

### Skill Not Activating
- Ensure keywords are mentioned (compute, database, networking, etc.)
- Try being more specific: "OCI compute instance" vs "server"
- Plugin may need restart

### CLI Commands Failing
- Verify OCI CLI is installed: `oci --version`
- Check configuration: `oci setup config`
- Validate compartment OCID exists
- Confirm IAM permissions

### MCP Server Issues
- Check `.mcp.json` configuration
- Verify servers are not disabled
- Restart Claude Code
- Check server logs for errors

## Using OCI Agent Skills with Other AI Coding Assistants

While OCI Agent Skills is a Claude Code plugin, the underlying knowledge, CLI commands, patterns, and best practices are valuable for any AI-powered development tool. Here's how to leverage this content with other platforms:

### GitHub Copilot

GitHub Copilot integrates with VS Code, JetBrains IDEs, and GitHub Codespaces. You can leverage OCI Agent Skills knowledge in several ways:

**In Copilot Chat:**
- Copy OCI CLI commands from this documentation into Copilot Chat with context: "I need to execute this OCI command: `oci compute instance list...` - explain what it does and how to use it"
- Ask Copilot to generate Python SDK code using the patterns documented in the skills
- Request IAM policy generation based on the examples in the IAM skill
- Use cost optimization queries from the FinOps skill to build cost analysis scripts

**In Code Generation:**
- Reference OCI CLI documentation within code comments to help Copilot generate appropriate commands
- Include skill examples in docstrings to guide Copilot's code suggestions
- Create a `.copilot-instructions` file at project root with OCI best practices from this documentation

**Example Copilot Chat Usage:**
```
Me: I need to list all running Autonomous Databases in my production compartment.
    Here's the OCI CLI command structure from oci-agent-skills:
    oci db autonomous-database list --compartment-id <ocid>

    Can you help me write a Python script that does this using the OCI SDK?

Copilot: [Generates Python code using OCI SDK based on the CLI pattern you provided]
```

### Opencode

Opencode is an open-source IDE plugin for extending AI capabilities. To integrate OCI Agent Skills knowledge:

**Setup:**
1. Clone or download the OCI Agent Skills repository: `git clone https://github.com/acedergren/oci-agent-skills.git`
2. Reference the skill files in your Opencode custom knowledge base
3. Configure Opencode to index the `skills/` directory for local context

**Usage:**
- OCI CLI commands from skills become available in Opencode's context window
- Cost optimization and monitoring patterns guide Opencode's recommendations
- IAM policy examples inform security-focused code generation
- Infrastructure as Code templates accelerate Terraform/Resource Manager scaffolding

**Knowledge Transfer:**
```markdown
# OCI Agent Skills Reference
- Compute: skills/compute-management/SKILL.md
- Networking: skills/networking-management/SKILL.md
- Database: skills/database-management/SKILL.md
- Monitoring: skills/monitoring-operations/SKILL.md
- FinOps: skills/finops-cost-optimization/SKILL.md
```

### Codex and OpenAI API

For Codex or any OpenAI API-based tools, create a custom system prompt that incorporates OCI knowledge:

**System Prompt Template:**
```
You are an expert Oracle Cloud Infrastructure (OCI) engineer.
Use these resources when helping with OCI tasks:

1. CLI Commands: [Include relevant CLI examples from skills/*/SKILL.md]
2. Best Practices: [Include security, cost, operational best practices]
3. Code Patterns: [Include Python SDK examples from documentation]
4. IAM Policies: [Include policy templates from iam-identity-management skill]

When generating OCI code, always:
- Use latest OCI SDK patterns
- Include error handling examples
- Reference security best practices
- Suggest monitoring and cost optimization
```

**API Usage Example:**
```python
import openai

# Load OCI knowledge from documentation
with open('skills/compute-management/SKILL.md', 'r') as f:
    oci_knowledge = f.read()

# Create system prompt with OCI context
system_prompt = f"""You are an OCI expert. Reference this knowledge:
{oci_knowledge}

Always provide CLI commands and SDK examples with explanations."""

response = openai.ChatCompletion.create(
    model="code-davinci-002",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": "Generate an OCI compute instance launch script"}
    ]
)
```

### General Cross-Platform Usage Tips

1. **Extract Reusable Content:**
   - Copy CLI commands and adapt them to your AI assistant's format
   - Use code examples as templates for your assistant's code generation
   - Reference best practices as guidelines in custom prompts

2. **Version Management:**
   - Keep a copy of specific skill versions your team uses
   - Track changes in OCI services using the version history
   - Update your custom prompts when new skills are released

3. **Custom Knowledge Bases:**
   - For enterprise teams, export skills content to internal wikis
   - Build custom documentation combining OCI Agent Skills with your organization's standards
   - Create domain-specific prompts for your AI assistant using skill patterns

4. **Maximizing AI Effectiveness:**
   - Provide context from relevant skills when asking AI assistants OCI questions
   - Include CLI command examples from skills to guide code generation
   - Reference specific best practices sections for security-focused work
   - Share the FinOps skill content for cost-related guidance

### Contributing Improvements

If you enhance these skills for use with other platforms, consider contributing back:
- Share integration patterns for Copilot, Opencode, or other tools
- Document best practices for using OCI Agent Skills in your AI assistant
- Report issues or suggest improvements via GitHub issues

## Community

### Report Issues & Suggest Features

Found a bug or have an idea? Help us improve!

- **🐛 Report bugs**: [Open an issue](https://github.com/acedergren/oci-agent-skills/issues) with details
- **💡 Suggest features**: [Request new skills](https://github.com/acedergren/oci-agent-skills/issues) or enhancements
- **❤️ Share feedback**: Use the discussions tab to share how you're using OCI Agent Skills

### Get Help

- **Troubleshooting**: Check the [Troubleshooting](#troubleshooting) section above
- **CLI Issues**: See [OCI CLI Reference](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/)
- **SDK Help**: Browse [OCI Python SDK docs](https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/)
- **Community Forums**: [OCI Community](https://community.oracle.com/customerconnect/categories/oci)

## Contributing

We welcome contributions from the community! Help us expand OCI Agent Skills:

### For Users
- Share your use cases and success stories
- Test new features and report feedback
- Suggest improvements or new skills
- Help other users in discussions and issues

### For Contributors

To add new skills or enhance existing ones:

1. **Fork and clone** the repository
2. **Create a branch** for your changes
3. **Add skill directory** under `skills/`
4. **Create `SKILL.md`** with YAML frontmatter following [AGENTS.md](./AGENTS.md)
5. **Include comprehensive** CLI examples, SDK patterns, best practices
6. **Add troubleshooting** section with common errors
7. **Test thoroughly** against current OCI CLI/SDK versions
8. **Open a pull request** with detailed description

**Contribution Guidelines:**
- Follow the [AGENTS.md](./AGENTS.md) standards
- Review [SECURITY.md](./SECURITY.md) for security requirements
- Update version numbers following [semantic versioning](https://semver.org/)
- Ensure commands are tested and documented
- Include IAM policy examples where applicable

See [AGENTS.md](./AGENTS.md) for detailed skill architecture and coding conventions.

## Resources

### Official Documentation
- [OCI Documentation](https://docs.oracle.com/en-us/iaas/Content/home.htm)
- [OCI CLI Reference](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/)
- [OCI Python SDK](https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/)
- [OCI Best Practices Guide](https://www.oracle.com/cloud/oci-best-practices-guide/)
- [Oracle Solutions and Architecture](https://docs.oracle.com/solutions/)
- [Oracle A-Team Chronicles](https://www.ateam-oracle.com/) - Technical deep-dives and best practices

### GitHub Repositories
- [oracle/oci-cli](https://github.com/oracle/oci-cli)
- [oracle/oci-python-sdk](https://github.com/oracle/oci-python-sdk)
- [oracle-devrel](https://github.com/oracle-devrel)
- [oracle/mcp](https://github.com/oracle/mcp)

### Community
- [OCI Community Forums](https://community.oracle.com/customerconnect/categories/oci)
- [Oracle Cloud Blog](https://blogs.oracle.com/cloud-infrastructure/)

## License

MIT License - See LICENSE file for details

## Community Resources

### Stay Updated
- **Watch the repo** for release notifications
- **Star on GitHub** to show your support
- **Follow updates** to stay informed about new skills

### Learn from Examples
- Check skill documentation for common patterns
- Review [resources section](#resources) for official guides
- Look at troubleshooting sections for solutions
- Search closed issues for common questions

### Connect with Others
- **GitHub Issues**: Ask questions, report bugs, suggest features
- **GitHub Discussions**: Share experiences and best practices
- **Oracle Community**: Connect with broader OCI community
- **Claude Code Docs**: Learn about Claude Code capabilities

## Made For Community

OCI Agent Skills is built by the community, for the community. This project aims to make Oracle Cloud Infrastructure accessible and powerful for everyone using Claude Code.

**Questions or feedback?** 
- 🎯 **Found a bug?** [Report it](https://github.com/acedergren/oci-agent-skills/issues)
- 💬 **Have ideas?** [Start a discussion](https://github.com/acedergren/oci-agent-skills/discussions)
- 📚 **Want to contribute?** [Read our contributing guide](#contributing)
- ⭐ **Like this project?** [Star us on GitHub](https://github.com/acedergren/oci-agent-skills)!

---

## Version History

This is a community-maintained project. All releases are managed by Alexander Cedergren.

### 1.2.0 (2026-01-26) - Community Release
- Community project clarification and marketplace publication
- Updated author information and contact
- FinOps & Cost Optimization skill
- Integrated 4 additional MCP servers (pricing, usage, resource-search, cloud-guard)
- Cost intelligence with ADB ML-based anomaly detection
- Budget management and alerting
- Resource optimization workflows
- Based on Oracle A-Team Chronicles FinOps series

### 1.1.0 (2026-01-26) - Community Release
- Enhanced GenAI skill with OCI OpenAI package integration
- Added agent building patterns for 5 frameworks
- Added Oracle best practices skill
- Well-Architected Framework guidance

### 1.0.0 (2026-01-26) - Community Release
- Initial release
- 7 comprehensive skills covering major OCI services
- MCP integration (oci-api, context7)
- Complete CLI command references
- Python SDK examples
- Best practices and troubleshooting guides
