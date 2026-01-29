# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository Overview

A collection of Oracle Cloud Infrastructure (OCI) agent skills for AI coding agents. Skills are packaged instructions that extend agent capabilities for cloud infrastructure automation.

**Community Project**: Created and maintained by Alexander Cedergren. Not an official Oracle product.

## Skill Structure

```
skills/
  {skill-name}/           # kebab-case directory name
    SKILL.md              # Required: skill definition with YAML frontmatter
    metadata.json         # Required: version, abstract, references
    references/           # Optional: CLI commands, patterns, heavy content
```

### Naming Conventions

- **Skill directory**: `kebab-case` (e.g., `compute-management`, `database-management`)
- **SKILL.md**: Always uppercase, always this exact filename
- **References**: `kebab-case.md` (e.g., `oci-compute-cli.md`)

### SKILL.md Format

```markdown
---
name: {skill-name}
description: {One sentence describing when to use this skill. Include trigger keywords.}
version: "X.Y.Z"
license: MIT
---

# {Skill Title}

{Brief description of what the skill does.}

## When to Apply

{Scenarios when this skill should be activated}
```

## Quality Standards (A++ Criteria)

All skills must pass:
1. **≥6 NEVERs** - Anti-patterns with specific reasons
2. **≤500 lines** - Progressive disclosure to references
3. **References directory** - CLI commands, patterns
4. **Loading triggers** - "WHEN TO LOAD" guidance embedded in workflow
5. **Knowledge Gap Disclaimer** - Acknowledge OCI CLI limitations

## Available Skills

| Skill | Description |
|-------|-------------|
| compute-management | VM lifecycle, shapes, capacity planning |
| networking-management | VCN, subnets, security lists, NSGs |
| database-management | ADB, DB Systems, backups |
| oracle-dba | ADB performance tuning, SQL optimization |
| monitoring-operations | Metrics, alarms, logging |
| secrets-management | Vault, keys, secrets |
| genai-services | OCI GenAI, embeddings, RAG |
| iam-identity-management | Users, groups, policies, dynamic groups |
| infrastructure-as-code | Terraform, Resource Manager |
| finops-cost-optimization | Cost analysis, budgets, optimization |
| best-practices | Well-Architected Framework, CIS benchmarks |
| landing-zones | Compartment hierarchy, hub-spoke topology |
| oci-events | Event-driven automation, CloudEvents |

## Installation

```bash
npx skills add acedergren/oci-agent-skills
```

## License

MIT
