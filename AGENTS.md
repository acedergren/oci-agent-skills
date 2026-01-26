# Agent Instructions for OCI Agent Skills

This document defines guidelines for AI agents and developers working within the OCI Agent Skills repository.

## Repository Purpose

The OCI Agent Skills plugin provides comprehensive, expert-level agent skills for Claude Code to manage Oracle Cloud Infrastructure (OCI) operations. Each skill covers a specific domain (compute, networking, databases, etc.) and includes complete CLI command references, Python SDK examples, best practices, and troubleshooting guides.

## Skill Architecture

All skills follow a consistent structure defined in `skills/<skill-name>/SKILL.md`:

### SKILL.md Format (YAML Frontmatter)

Every skill file **must** include YAML frontmatter with these required fields:

```yaml
---
name: <Skill Display Name>
description: <One-line description of skill purpose>
version: <Semantic version>
---
```

**Required Fields**:
- `name`: Display name for the skill (required, single-line scalar)
- `description`: Concise one-line description (required, single-line scalar)
- `version`: Semantic versioning (e.g., 1.0.0)

**Example**:
```yaml
---
name: OCI Compute Management
description: Launch, manage, and troubleshoot Oracle Cloud compute instances and bare metal servers
version: 1.0.0
---
```

### Skill Content Organization

After the YAML frontmatter, structure skills with these sections:

1. **Core Capabilities** - High-level overview of what the skill enables
2. **CLI Commands** - Organized by use case with complete command examples
3. **SDK Examples** - Python code samples using OCI Python SDK
4. **Best Practices** - Security, performance, and operational guidelines
5. **Common Workflows** - Step-by-step procedures for typical tasks
6. **Troubleshooting** - Error resolution and debugging guidance
7. **When to Use This Skill** - Keywords and scenarios that activate the skill
8. **Example Interactions** - Realistic user queries and responses

### What NOT to Include in Skills

Do not include auxiliary documentation in skill files:
- ❌ README.md files (confuses agents)
- ❌ INSTALLATION_GUIDE.md 
- ❌ CHANGELOG.md
- ❌ Getting started documentation (belongs in README.md at repo root)
- ❌ Tutorial content (unless directly related to the skill's core purpose)

## Coding Conventions

### CLI Command Examples

- Always use complete, copy-paste-ready command lines
- Include all required parameters (no placeholders for obvious values)
- Use `<placeholder>` syntax for values users must substitute (e.g., `<compartment-ocid>`)
- Provide context comments explaining what each command does
- Group related commands by use case

Example:
```bash
# List all running instances in a specific compartment
oci compute instance list \
  --compartment-id <compartment-ocid> \
  --lifecycle-state RUNNING
```

### Python SDK Examples

- Use modern OCI Python SDK patterns (v2.x+)
- Always include error handling
- Show how to authenticate (OCI config, environment variables, session tokens)
- Include inline comments explaining key steps
- Complete, runnable code samples when possible

### Documentation Tone

- **Audience**: Both experienced cloud operators AND developers new to OCI
- **Clarity**: Prioritize clarity over brevity; assume limited OCI knowledge
- **Examples**: Real-world examples over contrived scenarios
- **Warnings**: Highlight security implications, cost impacts, and operational gotchas

## Plugin Configuration Files

### plugin.json
- Central manifest for Claude Code plugin metadata
- Fields: `name`, `version`, `description`, `author`, `homepage`, `repository`, `keywords`, `license`, `category`
- Keep synchronized with marketplace.json

### marketplace.json
- Used for Claude Code marketplace registration
- Contains `owner`, `plugins` array with plugin details
- Source URLs must point to valid GitHub repository

### .mcp.json
- Model Context Protocol server configuration
- Lists enabled MCP servers (oci-api, context7, optional: pricing, usage, resource-search, cloud-guard)
- Servers can be disabled by setting `"disabled": true`

## Skill Activation

Skills are automatically activated when users mention relevant keywords. Each skill defines its own activation keywords in the "When to Use This Skill" section.

**Guidelines for keyword selection**:
- Use industry-standard terminology
- Include both formal names and common synonyms
- Be specific enough to avoid false activations
- Group related keywords together

Example (from FinOps skill):
```
Activate this skill when the user mentions:
- Cost optimization, savings, or reduction
- Budget management or alerts
- Usage analysis or reporting
- FinOps, financial operations, or cost intelligence
- Right-sizing resources
```

## Cross-Platform Compatibility

This plugin is Claude Code-specific, but skills content can be leveraged by other AI coding tools:

- **GitHub Copilot**: Reference CLI commands in Copilot Chat with context
- **Opencode**: Index skills directory as custom knowledge base
- **OpenAI Codex/API**: Include skill SKILL.md content in system prompts
- **Custom tools**: Extract CLI commands and patterns for custom prompts

See README.md "Using OCI Agent Skills with Other AI Coding Assistants" for detailed integration patterns.

## Version Management

- Use semantic versioning for all skills: MAJOR.MINOR.PATCH
- Update `version` in skill YAML frontmatter when modifying content
- Update `version` in plugin.json and marketplace.json for plugin-wide releases
- Document significant changes in README.md version history

## Code Quality Standards

### Command Accuracy
- All CLI commands must be syntactically correct and executable
- Test commands before including (when possible within your constraints)
- Provide context about prerequisites and IAM permissions required
- Include error handling patterns for common failure modes

### Documentation Completeness
- Every major command should include explanation of what it does
- Every example should be copy-paste-ready (no incomplete placeholders)
- Cross-reference related commands and skills when appropriate
- Include links to official OCI documentation

### Security Guidelines
- Never include hardcoded credentials or API keys in examples
- Highlight when commands require specific IAM permissions
- Warn about publicly accessible resources and cost implications
- Recommend vault/secrets management for sensitive data

## Integration with Optional MCP Servers

Four optional MCP servers enhance plugin functionality:

1. **oracle-oci-pricing**: Real-time pricing lookups
2. **oracle-oci-usage**: Cost and usage analytics  
3. **oracle-oci-resource-search**: Cross-compartment discovery
4. **oracle-oci-cloud-guard**: Security recommendations

Skills should note when optional servers provide enhanced capabilities but must work independently using OCI CLI.

## Testing Skill Content

While full end-to-end testing requires OCI infrastructure:

- Verify CLI command syntax matches OCI CLI documentation
- Check Python SDK examples against latest SDK version (v2.x+)
- Validate IAM policy examples by checking against OCI documentation
- Ensure code snippets follow Python style conventions (PEP 8)

## When to Update Skills

**Update when**:
- OCI CLI or SDK updates introduce new commands/parameters
- Best practices change (based on Oracle guidance or community feedback)
- New OCI services become available
- Security or cost implications change
- Troubleshooting section needs additions

**Don't update for**:
- Minor wording improvements (unless clarity is significantly impacted)
- Adding "nice to have" information (keep focused)
- Adding duplicate examples (consolidate instead)

## Contributing New Skills

To add a new skill:

1. Create directory: `skills/<skill-category>/`
2. Create `SKILL.md` with proper YAML frontmatter
3. Follow the content organization guidelines above
4. Update README.md skills reference section
5. Add keywords to main plugin documentation
6. Test activation by mentioning relevant keywords

## Repository Structure

```
oci-agent-skills/
├── AGENTS.md                          # This file - agent instructions
├── README.md                          # Main documentation
├── .claude-plugin/
│   ├── plugin.json                    # Claude Code plugin manifest
│   └── marketplace.json               # Marketplace registration
├── .mcp.json                          # MCP server configuration
├── docs/
│   └── MCP_SETUP.md                   # Optional MCP setup guide
├── skills/
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
│   └── finops-cost-optimization/
│       └── SKILL.md
└── LICENSE
```

## References

- [Codex Skill Structure Standard](https://openai.com/docs/agents/building/skills)
- [OCI CLI Documentation](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/)
- [OCI Python SDK](https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)
